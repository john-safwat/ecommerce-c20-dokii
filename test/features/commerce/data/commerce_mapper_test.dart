import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/features/commerce/data/mapper/commerce_mapper.dart';
import 'package:route_ecommerce/features/commerce/data/models/banners_response_dto.dart';
import 'package:route_ecommerce/features/commerce/data/models/categories_response_dto.dart';
import 'package:route_ecommerce/features/commerce/data/models/products_response_dto.dart';

void main() {
  late CommerceMapper mapper;

  setUp(() {
    mapper = CommerceMapper();
  });

  group('CommerceMapper', () {
    test('categoryDtoToEntity maps fields and falls back to empty strings', () {
      final dto = CategoryDto(
        id: 'cat-1',
        name: 'Electronics',
        image: 'https://example.com/cat.png',
      );

      final entity = mapper.categoryDtoToEntity(dto);

      expect(entity.id, 'cat-1');
      expect(entity.name, 'Electronics');
      expect(entity.image, 'https://example.com/cat.png');

      final emptyEntity = mapper.categoryDtoToEntity(CategoryDto());
      expect(emptyEntity.id, '');
      expect(emptyEntity.name, '');
      expect(emptyEntity.image, '');
    });

    test('productDtoToEntity maps discounted and non-discounted products', () {
      final discounted = ProductDto(
        id: 'prod-1',
        title: 'Headphones',
        imageCover: 'https://example.com/p1.png',
        ratingsAverage: 4.5,
        price: 200,
        priceAfterDiscount: 150,
      );

      final discountedEntity = mapper.productDtoToEntity(discounted);
      expect(discountedEntity.id, 'prod-1');
      expect(discountedEntity.name, 'Headphones');
      expect(discountedEntity.image, 'https://example.com/p1.png');
      expect(discountedEntity.reviews, 4.5);
      expect(discountedEntity.price, 200.0);
      expect(discountedEntity.priceAfterDiscount, 150.0);

      final fullPrice = ProductDto(
        id: 'prod-2',
        title: 'Mouse',
        imageCover: 'https://example.com/p2.png',
        ratingsAverage: 4.0,
        price: 100,
      );

      final fullPriceEntity = mapper.productDtoToEntity(fullPrice);
      expect(fullPriceEntity.price, 100.0);
      expect(fullPriceEntity.priceAfterDiscount, 100.0);
    });

    test('bannerDtoToEntity maps alignment and colors', () {
      final dto = BannerDto(
        image: 'assets/images/advertisement_1.png',
        title: 'Up To 25% Off',
        categoryName: 'Headphones',
        alignment: 'end',
        buttonBackGroundColor: 4278206850,
        buttonForGroundColor: 4294967295,
      );

      final entity = mapper.bannerDtoToEntity(dto);
      expect(entity.image, 'assets/images/advertisement_1.png');
      expect(entity.title, 'Up To 25% Off');
      expect(entity.categoryName, 'Headphones');
      expect(entity.alignment, Alignment.centerRight);
      expect(entity.buttonBackGroundColor, const Color(0xFF004182));
      expect(entity.buttonForGroundColor, const Color(0xFFFFFFFF));
    });
  });
}
