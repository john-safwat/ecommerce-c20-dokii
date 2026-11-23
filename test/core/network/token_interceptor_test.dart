import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/network/token_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeRequestInterceptorHandler extends RequestInterceptorHandler {
  RequestOptions? nextOptions;
  int nextCallCount = 0;

  @override
  void next(RequestOptions requestOptions) {
    nextCallCount++;
    nextOptions = requestOptions;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TokenInterceptor', () {
    test('attaches token header when non-empty token is stored', () async {
      SharedPreferences.setMockInitialValues({'token': 'jwt-token-123'});
      final prefs = await SharedPreferences.getInstance();
      final interceptor = TokenInterceptor(prefs);
      final options = RequestOptions(path: '/api/v1/cart');
      final handler = _FakeRequestInterceptorHandler();

      interceptor.onRequest(options, handler);

      expect(options.headers['token'], equals('jwt-token-123'));
      expect(handler.nextCallCount, equals(1));
      expect(handler.nextOptions, same(options));
    });

    test('does not attach token header when token is missing', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final interceptor = TokenInterceptor(prefs);
      final options = RequestOptions(path: '/api/v1/products');
      final handler = _FakeRequestInterceptorHandler();

      interceptor.onRequest(options, handler);

      expect(options.headers.containsKey('token'), isFalse);
      expect(handler.nextCallCount, equals(1));
      expect(handler.nextOptions, same(options));
    });

    test(
      'does not attach token header when token is empty or whitespace',
      () async {
        SharedPreferences.setMockInitialValues({'token': '   '});
        final prefs = await SharedPreferences.getInstance();
        final interceptor = TokenInterceptor(prefs);
        final options = RequestOptions(path: '/api/v1/categories');
        final handler = _FakeRequestInterceptorHandler();

        interceptor.onRequest(options, handler);

        expect(options.headers.containsKey('token'), isFalse);
        expect(handler.nextCallCount, equals(1));
        expect(handler.nextOptions, same(options));
      },
    );
  });
}
