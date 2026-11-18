class CategoriesResponseDto {
  CategoriesResponseDto({this.results, this.data});

  CategoriesResponseDto.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      results = (json['results'] as num?)?.toInt();
      final rawData = json['data'];
      if (rawData is List) {
        data = rawData.map(CategoryDto.fromJson).toList();
      }
    }
  }

  int? results;
  List<CategoryDto>? data;

  Map<String, dynamic> toJson() {
    return {
      'results': results,
      if (data != null) 'data': data!.map((e) => e.toJson()).toList(),
    };
  }
}

class CategoryDto {
  CategoryDto({this.id, this.name, this.slug, this.image});

  CategoryDto.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      id = json['_id'] as String?;
      name = json['name'] as String?;
      slug = json['slug'] as String?;
      image = json['image'] as String?;
    }
  }

  String? id;
  String? name;
  String? slug;
  String? image;

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'slug': slug, 'image': image};
  }
}
