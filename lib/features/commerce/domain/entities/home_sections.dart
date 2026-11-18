import 'package:route_ecommerce/features/commerce/domain/entities/banner_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/category_entity.dart';
import 'package:route_ecommerce/features/commerce/domain/entities/product_entity.dart';

sealed class HomeSections {
  int index;
  HomeSections(this.index);
}

class BannersSection extends HomeSections {
  final List<BannerEntity> banners;
  BannersSection(super.index, this.banners);
}

class CategoriesSection extends HomeSections {
  final String title;
  final List<CategoryEntity> categories;

  CategoriesSection(super.index, this.categories, this.title);
}

class ProductsListSection extends HomeSections {
  final String title;
  final List<ProductEntity> products;

  ProductsListSection(super.index, this.products, this.title);
}
