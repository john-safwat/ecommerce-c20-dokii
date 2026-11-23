import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Attaches the persisted auth token from [SharedPreferences] to every
/// outgoing request under the `token` header.
@lazySingleton
class TokenInterceptor extends Interceptor {
  static const String _tokenKey = 'token';
  static const String _tokenHeader = 'token';

  final SharedPreferences _sharedPreferences;

  TokenInterceptor(this._sharedPreferences);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _sharedPreferences.getString(_tokenKey);
    if (token != null && token.trim().isNotEmpty) {
      options.headers[_tokenHeader] = token;
    }
    handler.next(options);
  }
}
