import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/core/base/base_cubit.dart';
import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_details_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/use_cases/get_product_details_use_case.dart';
import 'package:route_ecommerce/features/commerce/presentation/product_details/product_details_states.dart';

@injectable
class ProductDetailsCubit
    extends
        BaseCubit<
          ProductDetailsStates,
          ProductDetailsAction,
          ProductDetailsNavigationAction
        > {
  final GetProductDetailsUseCase _getProductDetailsUseCase;

  ProductDetailsCubit(this._getProductDetailsUseCase)
    : super(ProductDetailsStates());

  @override
  Future<void> doAction(ProductDetailsAction action) async {
    switch (action) {
      case LoadProductDetailsAction(:final productId):
        await _loadProductDetails(productId);
      case IncrementQuantityAction():
        _incrementQuantity();
      case DecrementQuantityAction():
        _decrementQuantity();
      case SelectSizeAction(:final index):
        emit(state.copyWith(selectedSizeIndex: index));
      case SelectColorAction(:final index):
        emit(state.copyWith(selectedColorIndex: index));
      case ToggleWishlistAction():
        emit(state.copyWith(isWishlisted: !state.isWishlisted));
      case ToggleDescriptionAction():
        emit(
          state.copyWith(isDescriptionExpanded: !state.isDescriptionExpanded),
        );
      case AddToCartAction():
        if (state.productResource.data != null) {
          emitNavigation(const ShowAddedToCartToast());
        }
    }
  }

  Future<void> _loadProductDetails(String productId) async {
    emit(state.copyWith(productResource: Resources.loading()));
    final result = await _getProductDetailsUseCase(productId);
    if (isClosed) return;

    switch (result) {
      case Success<ProductDetailsEntity>():
        emit(state.copyWith(productResource: Resources.success(result.data)));
      case Failure<ProductDetailsEntity>():
        emit(state.copyWith(productResource: Resources.error(result.message)));
        emitNavigation(ShowProductDetailsToast(result.message, isError: true));
    }
  }

  void _incrementQuantity() {
    final maxQty = state.productResource.data?.quantity ?? 0;
    if (maxQty > 0 && state.quantity >= maxQty) return;
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void _decrementQuantity() {
    if (state.quantity <= 1) return;
    emit(state.copyWith(quantity: state.quantity - 1));
  }
}
