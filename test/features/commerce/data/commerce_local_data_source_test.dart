import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/features/commerce/data/data_source/commerce_local_data_source.dart';

class _FakeAssetBundle extends CachingAssetBundle {
  final String jsonPayload;

  _FakeAssetBundle(this.jsonPayload);

  @override
  Future<ByteData> load(String key) async {
    final bytes = utf8.encode(jsonPayload);
    return ByteData.sublistView(Uint8List.fromList(bytes));
  }
}

void main() {
  test('CommerceLocalDataSourceImpl parses banners json', () async {
    const payload = '''
    {
      "banners": [
        {
          "image": "assets/images/advertisement_1.png",
          "title": "Up To 25% Off",
          "categoryName": "Headphones",
          "alignment": "end",
          "buttonBackGroundColor": 4278206850,
          "buttonForGroundColor": 4294967295
        }
      ]
    }
    ''';

    final dataSource = CommerceLocalDataSourceImpl(
      assetBundle: _FakeAssetBundle(payload),
    );

    final result = await dataSource.getBanners();

    expect(result.banners, hasLength(1));
    expect(result.banners!.first.title, 'Up To 25% Off');
    expect(result.banners!.first.alignment, 'end');
  });
}
