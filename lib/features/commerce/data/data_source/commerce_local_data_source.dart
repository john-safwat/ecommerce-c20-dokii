import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:route_ecommerce/features/commerce/data/models/banners_response_dto.dart';

abstract interface class CommerceLocalDataSource {
  Future<BannersResponseDto> getBanners();
}

@Injectable(as: CommerceLocalDataSource)
class CommerceLocalDataSourceImpl implements CommerceLocalDataSource {
  static const String _bannersAssetPath = 'assets/files/banners.json';

  final AssetBundle _assetBundle;

  CommerceLocalDataSourceImpl({@ignoreParam AssetBundle? assetBundle})
    : _assetBundle = assetBundle ?? rootBundle;

  @override
  Future<BannersResponseDto> getBanners() async {
    final rawJson = await _assetBundle.loadString(_bannersAssetPath);
    final decoded = jsonDecode(rawJson);
    return BannersResponseDto.fromJson(decoded);
  }
}
