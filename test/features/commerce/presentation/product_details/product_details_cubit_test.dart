import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_details_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_product_details_use_case.dart';
import 'package:route_ecommerce/features/commerce/presentation/product_details/product_details_cubit.dart';
import 'package:route_ecommerce/features/commerce/presentation/product_details/product_details_states.dart';

class _FakeGetProductDetailsUseCase implements GetProductDetailsUseCase {
  final Future<Result<ProductDetailsEntity>> Function(String id) _handler;

  _FakeGetProductDetailsUseCase(this._handler);

  @override
  Future<Result<ProductDetailsEntity>> call(String productId) =>
      _handler(productId);
}

const _sampleProduct = ProductDetailsEntity(
  id: 'p1',
  title: 'Nike Air Jordon',
  description: 'Athletic footwear',
  images: ['https://example.com/1.png', 'https://example.com/2.png'],
  price: 4000,
  priceAfterDiscount: 3500,
  sold: 3230,
  ratingsAverage: 4.8,
  ratingsQuantity: 7500,
  quantity: 3,
);

void main() {
  group('ProductDetailsCubit', () {
    test('initial state has default values', () {
      final cubit = ProductDetailsCubit(
        _FakeGetProductDetailsUseCase((_) async => Success(_sampleProduct)),
      );

      expect(cubit.state.productResource.status, Status.initial);
      expect(cubit.state.quantity, 1);
      expect(cubit.state.isWishlisted, isFalse);
      expect(cubit.state.isDescriptionExpanded, isFalse);
      cubit.close();
    });

    test('LoadProductDetailsAction emits loading then success', () async {
      final cubit = ProductDetailsCubit(
        _FakeGetProductDetailsUseCase((_) async => Success(_sampleProduct)),
      );

      final statuses = <Status>[];
      final sub = cubit.stream.listen(
        (s) => statuses.add(s.productResource.status),
      );

      await cubit.doAction(const LoadProductDetailsAction('p1'));
      await Future<void>.delayed(Duration.zero);

      expect(statuses, [Status.loading, Status.success]);
      expect(cubit.state.productResource.data?.title, 'Nike Air Jordon');
      await sub.cancel();
      await cubit.close();
    });

    test('LoadProductDetailsAction emits error and toast on failure', () async {
      final cubit = ProductDetailsCubit(
        _FakeGetProductDetailsUseCase((_) async => Failure('Network error')),
      );

      final navEvents = <ProductDetailsNavigationAction>[];
      final navSub = cubit.navStream.listen(navEvents.add);

      await cubit.doAction(const LoadProductDetailsAction('p1'));
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.productResource.status, Status.error);
      expect(navEvents.single, isA<ShowProductDetailsToast>());
      await navSub.cancel();
      await cubit.close();
    });

    test(
      'quantity increments up to stock limit and decrements down to 1',
      () async {
        final cubit = ProductDetailsCubit(
          _FakeGetProductDetailsUseCase((_) async => Success(_sampleProduct)),
        );

        await cubit.doAction(const LoadProductDetailsAction('p1'));
        await cubit.doAction(const IncrementQuantityAction());
        expect(cubit.state.quantity, 2);

        await cubit.doAction(const IncrementQuantityAction());
        expect(cubit.state.quantity, 3);

        await cubit.doAction(const IncrementQuantityAction());
        expect(cubit.state.quantity, 3);

        await cubit.doAction(const DecrementQuantityAction());
        expect(cubit.state.quantity, 2);

        await cubit.doAction(const DecrementQuantityAction());
        await cubit.doAction(const DecrementQuantityAction());
        expect(cubit.state.quantity, 1);

        await cubit.close();
      },
    );

    test(
      'toggles wishlist, description, size, color, and emits add to cart',
      () async {
        final cubit = ProductDetailsCubit(
          _FakeGetProductDetailsUseCase((_) async => Success(_sampleProduct)),
        );

        final navEvents = <ProductDetailsNavigationAction>[];
        final navSub = cubit.navStream.listen(navEvents.add);

        await cubit.doAction(const LoadProductDetailsAction('p1'));
        await cubit.doAction(const ToggleWishlistAction());
        await cubit.doAction(const ToggleDescriptionAction());
        await cubit.doAction(const SelectSizeAction(0));
        await cubit.doAction(const SelectColorAction(3));
        await cubit.doAction(const AddToCartAction());
        await Future<void>.delayed(Duration.zero);

        expect(cubit.state.isWishlisted, isTrue);
        expect(cubit.state.isDescriptionExpanded, isTrue);
        expect(cubit.state.selectedSizeIndex, 0);
        expect(cubit.state.selectedColorIndex, 3);
        expect(navEvents.last, isA<ShowAddedToCartToast>());

        await navSub.cancel();
        await cubit.close();
      },
    );
  });
}
