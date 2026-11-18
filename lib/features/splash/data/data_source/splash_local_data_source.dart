import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class SplashLocalDataSource {
  String? getToken();
}

@Injectable(as: SplashLocalDataSource)
class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  static const String _tokenKey = 'token';
  final SharedPreferences sharedPreferences;

  SplashLocalDataSourceImpl(this.sharedPreferences);

  @override
  String? getToken() {
    return sharedPreferences.getString(_tokenKey);
  }
}
