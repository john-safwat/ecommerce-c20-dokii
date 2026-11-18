class ProductsResponseDto {
  ProductsResponseDto({this.results, this.metadata, this.data});

  ProductsResponseDto.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      results = (json['results'] as num?)?.toInt();
      final rawMetadata = json['metadata'];
      if (rawMetadata is Map<String, dynamic>) {
        metadata = PaginationMetadataDto.fromJson(rawMetadata);
      }
      final rawData = json['data'];
      if (rawData is List) {
        data = rawData.map(ProductDto.fromJson).toList();
      }
    }
  }

  int? results;
  PaginationMetadataDto? metadata;
  List<ProductDto>? data;

  Map<String, dynamic> toJson() {
    return {
      'results': results,
      if (metadata != null) 'metadata': metadata!.toJson(),
      if (data != null) 'data': data!.map((e) => e.toJson()).toList(),
    };
  }
}

class PaginationMetadataDto {
  PaginationMetadataDto({
    this.currentPage,
    this.numberOfPages,
    this.limit,
    this.nextPage,
  });

  PaginationMetadataDto.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      currentPage = (json['currentPage'] as num?)?.toInt();
      numberOfPages = (json['numberOfPages'] as num?)?.toInt();
      limit = (json['limit'] as num?)?.toInt();
      nextPage = (json['nextPage'] as num?)?.toInt();
    }
  }

  int? currentPage;
  int? numberOfPages;
  int? limit;
  int? nextPage;

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'numberOfPages': numberOfPages,
      'limit': limit,
      'nextPage': nextPage,
    };
  }
}

class ProductDetailsResponseDto {
  ProductDetailsResponseDto({this.data});

  ProductDetailsResponseDto.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      final rawData = json['data'];
      if (rawData is Map<String, dynamic>) {
        data = ProductDto.fromJson(rawData);
      }
    }
  }

  ProductDto? data;

  Map<String, dynamic> toJson() {
    return {if (data != null) 'data': data!.toJson()};
  }
}

class ProductDto {
  ProductDto({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.quantity,
    this.sold,
    this.price,
    this.priceAfterDiscount,
    this.imageCover,
    this.images,
    this.ratingsAverage,
    this.ratingsQuantity,
  });

  ProductDto.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      id = (json['_id'] ?? json['id']) as String?;
      title = json['title'] as String?;
      slug = json['slug'] as String?;
      description = json['description'] as String?;
      quantity = (json['quantity'] as num?)?.toInt();
      sold = (json['sold'] as num?)?.toInt();
      price = (json['price'] as num?)?.toDouble();
      priceAfterDiscount = (json['priceAfterDiscount'] as num?)?.toDouble();
      imageCover = json['imageCover'] as String?;
      final rawImages = json['images'];
      if (rawImages is List) {
        images = rawImages.whereType<String>().toList();
      }
      ratingsAverage = (json['ratingsAverage'] as num?)?.toDouble();
      ratingsQuantity = (json['ratingsQuantity'] as num?)?.toInt();
    }
  }

  String? id;
  String? title;
  String? slug;
  String? description;
  int? quantity;
  int? sold;
  double? price;
  double? priceAfterDiscount;
  String? imageCover;
  List<String>? images;
  double? ratingsAverage;
  int? ratingsQuantity;

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'slug': slug,
      'description': description,
      'quantity': quantity,
      'sold': sold,
      'price': price,
      'priceAfterDiscount': priceAfterDiscount,
      'imageCover': imageCover,
      if (images != null) 'images': images,
      'ratingsAverage': ratingsAverage,
      'ratingsQuantity': ratingsQuantity,
    };
  }
}
