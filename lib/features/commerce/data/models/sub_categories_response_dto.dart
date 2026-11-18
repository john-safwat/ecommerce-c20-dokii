class SubCategoriesResponseDto {
  SubCategoriesResponseDto({this.results, this.data});

  SubCategoriesResponseDto.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      results = (json['results'] as num?)?.toInt();
      final rawData = json['data'];
      if (rawData is List) {
        data = rawData.map(SubCategoryDto.fromJson).toList();
      }
    }
  }

  int? results;
  List<SubCategoryDto>? data;

  Map<String, dynamic> toJson() {
    return {
      'results': results,
      if (data != null) 'data': data!.map((e) => e.toJson()).toList(),
    };
  }
}

class SubCategoryDto {
  SubCategoryDto({this.id, this.name, this.slug, this.category, this.image});

  SubCategoryDto.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      id = json['_id'] as String?;
      name = json['name'] as String?;
      slug = json['slug'] as String?;
      category = json['category'] as String?;
      image = json['image'] as String?;
    }
  }

  String? id;
  String? name;
  String? slug;
  String? category;
  String? image;

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'category': category,
      'image': image,
    };
  }
}
