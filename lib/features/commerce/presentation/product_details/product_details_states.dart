import 'package:route_ecommerce/core/base/resources.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_details_entity.dart';

class ProductDetailsStates {
  final Resources<ProductDetailsEntity> productResource;
  final int quantity;
  final int selectedSizeIndex;
  final int selectedColorIndex;
  final bool isWishlisted;
  final bool isDescriptionExpanded;

  ProductDetailsStates({
    Resources<ProductDetailsEntity>? productResource,
    this.quantity = 1,
    this.selectedSizeIndex = 2,
    this.selectedColorIndex = 1,
    this.isWishlisted = false,
    this.isDescriptionExpanded = false,
  }) : productResource = productResource ?? Resources.init();

  ProductDetailsStates copyWith({
    Resources<ProductDetailsEntity>? productResource,
    int? quantity,
    int? selectedSizeIndex,
    int? selectedColorIndex,
    bool? isWishlisted,
    bool? isDescriptionExpanded,
  }) {
    return ProductDetailsStates(
      productResource: productResource ?? this.productResource,
      quantity: quantity ?? this.quantity,
      selectedSizeIndex: selectedSizeIndex ?? this.selectedSizeIndex,
      selectedColorIndex: selectedColorIndex ?? this.selectedColorIndex,
      isWishlisted: isWishlisted ?? this.isWishlisted,
      isDescriptionExpanded:
          isDescriptionExpanded ?? this.isDescriptionExpanded,
    );
  }
}

sealed class ProductDetailsAction {
  const ProductDetailsAction();
}

class LoadProductDetailsAction extends ProductDetailsAction {
  final String productId;

  const LoadProductDetailsAction(this.productId);
}

class IncrementQuantityAction extends ProductDetailsAction {
  const IncrementQuantityAction();
}

class DecrementQuantityAction extends ProductDetailsAction {
  const DecrementQuantityAction();
}

class SelectSizeAction extends ProductDetailsAction {
  final int index;

  const SelectSizeAction(this.index);
}

class SelectColorAction extends ProductDetailsAction {
  final int index;

  const SelectColorAction(this.index);
}

class ToggleWishlistAction extends ProductDetailsAction {
  const ToggleWishlistAction();
}

class ToggleDescriptionAction extends ProductDetailsAction {
  const ToggleDescriptionAction();
}

class AddToCartAction extends ProductDetailsAction {
  const AddToCartAction();
}

sealed class ProductDetailsNavigationAction {
  const ProductDetailsNavigationAction();
}

class ShowProductDetailsToast extends ProductDetailsNavigationAction {
  final String message;
  final bool isError;

  const ShowProductDetailsToast(this.message, {this.isError = false});
}

class ShowAddedToCartToast extends ProductDetailsNavigationAction {
  const ShowAddedToCartToast();
}
