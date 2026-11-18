class BannersResponseDto {
  BannersResponseDto({this.banners});

  BannersResponseDto.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      final rawBanners = json['banners'];
      if (rawBanners is List) {
        banners = rawBanners.map(BannerDto.fromJson).toList();
      }
    }
  }

  List<BannerDto>? banners;

  Map<String, dynamic> toJson() {
    return {
      if (banners != null) 'banners': banners!.map((e) => e.toJson()).toList(),
    };
  }
}

class BannerDto {
  BannerDto({
    this.image,
    this.title,
    this.categoryName,
    this.alignment,
    this.buttonBackGroundColor,
    this.buttonForGroundColor,
  });

  BannerDto.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      image = json['image'] as String?;
      title = json['title'] as String?;
      categoryName = json['categoryName'] as String?;
      alignment = json['alignment'] as String?;
      buttonBackGroundColor = (json['buttonBackGroundColor'] as num?)?.toInt();
      buttonForGroundColor = (json['buttonForGroundColor'] as num?)?.toInt();
    }
  }

  String? image;
  String? title;
  String? categoryName;
  String? alignment;
  int? buttonBackGroundColor;
  int? buttonForGroundColor;

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
      'categoryName': categoryName,
      'alignment': alignment,
      'buttonBackGroundColor': buttonBackGroundColor,
      'buttonForGroundColor': buttonForGroundColor,
    };
  }
}
