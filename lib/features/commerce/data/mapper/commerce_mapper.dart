import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/features/commerce/data/models/banners_response_dto.dart';
import 'package:route_ecommerce/features/commerce/data/models/categories_response_dto.dart';
import 'package:route_ecommerce/features/commerce/data/models/products_response_dto.dart';
import 'package:route_ecommerce/features/commerce/data/models/sub_categories_response_dto.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/banner_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/paginated_products_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_details_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/sub_category_entity.dart';

@injectable
class CommerceMapper {
  CategoryEntity categoryDtoToEntity(CategoryDto dto) {
    return CategoryEntity(dto.id ?? '', dto.image ?? '', dto.name ?? '');
  }

  SubCategoryEntity subCategoryDtoToEntity(SubCategoryDto dto) {
    return SubCategoryEntity(
      id: dto.id ?? '',
      name: dto.name ?? '',
      slug: dto.slug ?? '',
      categoryId: dto.category ?? '',
      image: dto.image ?? '',
    );
  }

  ProductEntity productDtoToEntity(ProductDto dto) {
    final price = dto.price ?? 0.0;
    return ProductEntity(
      dto.id ?? '',
      dto.title ?? '',
      dto.imageCover ?? '',
      dto.ratingsAverage ?? 0.0,
      price,
      dto.priceAfterDiscount ?? price,
    );
  }

  ProductDetailsEntity productDtoToDetailsEntity(ProductDto dto) {
    final price = dto.price ?? 0.0;
    final rawImages = dto.images ?? const <String>[];
    final images = rawImages.isNotEmpty
        ? rawImages
        : <String>[
            if (dto.imageCover != null && dto.imageCover!.isNotEmpty)
              dto.imageCover!,
          ];
    return ProductDetailsEntity(
      id: dto.id ?? '',
      title: dto.title ?? '',
      description: dto.description ?? '',
      images: images,
      price: price,
      priceAfterDiscount: dto.priceAfterDiscount ?? price,
      sold: dto.sold ?? 0,
      ratingsAverage: dto.ratingsAverage ?? 0.0,
      ratingsQuantity: dto.ratingsQuantity ?? 0,
      quantity: dto.quantity ?? 0,
    );
  }

  PaginatedProductsEntity productsResponseToPaginatedEntity(
    ProductsResponseDto dto,
  ) {
    final products = (dto.data ?? []).map(productDtoToEntity).toList();
    final metadata = dto.metadata;
    return PaginatedProductsEntity(
      products: products,
      currentPage: metadata?.currentPage ?? 1,
      numberOfPages: metadata?.numberOfPages ?? 1,
      nextPage: metadata?.nextPage,
    );
  }

  BannerEntity bannerDtoToEntity(BannerDto dto) {
    return BannerEntity(
      dto.image ?? '',
      dto.title ?? '',
      dto.categoryName ?? '',
      _parseAlignment(dto.alignment),
      Color(dto.buttonBackGroundColor ?? 0xFFFFFFFF),
      Color(dto.buttonForGroundColor ?? 0xFF000000),
    );
  }

  Alignment _parseAlignment(String? value) {
    return switch (value?.toLowerCase()) {
      'start' => Alignment.centerLeft,
      'end' => Alignment.centerRight,
      'center' => Alignment.center,
      _ => Alignment.centerLeft,
    };
  }
}
