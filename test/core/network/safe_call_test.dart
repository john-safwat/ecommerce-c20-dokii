import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:route_ecommerce/core/network/api_result.dart';
import 'package:route_ecommerce/core/network/safe_call.dart';

void main() {
  final requestOptions = RequestOptions(path: '/test');

  DioException dioException(
    DioExceptionType type, {
    Response<dynamic>? response,
    Object? error,
    String? message,
  }) {
    return DioException(
      requestOptions: requestOptions,
      type: type,
      response: response,
      error: error,
      message: message,
    );
  }

  Response<dynamic> dioResponse({
    dynamic data,
    int? statusCode,
    String? statusMessage,
  }) {
    return Response<dynamic>(
      requestOptions: requestOptions,
      data: data,
      statusCode: statusCode,
      statusMessage: statusMessage,
    );
  }

  group('safeCall', () {
    test('returns Success when call completes normally', () async {
      final result = await safeCall<String>(() async => Success('ok'));

      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, 'ok');
    });

    test(
      'catches async Exception and returns Failure via errorParser',
      () async {
        final result = await safeCall<String>(() async {
          await Future<void>.delayed(Duration.zero);
          throw dioException(
            DioExceptionType.badResponse,
            response: dioResponse(
              statusCode: 400,
              data: {'message': 'Email already exists'},
            ),
          );
        });

        expect(result, isA<Failure<String>>());
        final failure = result as Failure<String>;
        expect(failure.message, 'Email already exists');
        expect(failure.exception, isA<DioException>());
      },
    );

    test('catches non-Exception Error without throwing', () async {
      final result = await safeCall<String>(() async {
        throw StateError('boom');
      });

      expect(result, isA<Failure<String>>());
      expect(
        (result as Failure<String>).message,
        'An unexpected error occurred.',
      );
    });
  });

  group('errorParser - DioException', () {
    test('handles timeout types', () async {
      for (final type in [
        DioExceptionType.connectionTimeout,
        DioExceptionType.sendTimeout,
        DioExceptionType.receiveTimeout,
        DioExceptionType.transformTimeout,
      ]) {
        final result = await errorParser<void>(dioException(type));
        expect(result, isA<Failure<void>>());
        expect(
          (result as Failure<void>).message,
          'Connection timed out. Please try again.',
        );
      }
    });

    test('handles badCertificate', () async {
      final result = await errorParser<void>(
        dioException(DioExceptionType.badCertificate),
      );
      expect(
        (result as Failure<void>).message,
        'Invalid security certificate. Unable to establish a secure connection.',
      );
    });

    test('handles cancel', () async {
      final result = await errorParser<void>(
        dioException(DioExceptionType.cancel),
      );
      expect((result as Failure<void>).message, 'Request was cancelled.');
    });

    test('handles connectionError', () async {
      final result = await errorParser<void>(
        dioException(DioExceptionType.connectionError),
      );
      expect(
        (result as Failure<void>).message,
        'No internet connection. Please check your network and try again.',
      );
    });

    test('extracts message from Map API response on badResponse', () async {
      final result = await errorParser<void>(
        dioException(
          DioExceptionType.badResponse,
          response: dioResponse(
            statusCode: 401,
            data: {
              'statusMsg': 'fail',
              'message': '  Invalid email or password  ',
            },
          ),
        ),
      );

      expect((result as Failure<void>).message, 'Invalid email or password');
    });

    test(
      'extracts message from JSON String API response on badResponse',
      () async {
        final result = await errorParser<void>(
          dioException(
            DioExceptionType.badResponse,
            response: dioResponse(
              statusCode: 422,
              data: '{"message": "Validation failed for phone"}',
            ),
          ),
        );

        expect(
          (result as Failure<void>).message,
          'Validation failed for phone',
        );
      },
    );

    test(
      'falls back to status code messages when API message is missing or empty',
      () async {
        final cases = <int?, String>{
          400: 'Bad request. Please check your input.',
          401: 'Unauthorized. Please log in again.',
          403:
              'Access denied. You do not have permission to perform this action.',
          404: 'Requested resource was not found.',
          408: 'Request timed out. Please try again.',
          409: 'Conflict occurred. Please try again.',
          422: 'Validation failed. Please check your input.',
          429: 'Too many requests. Please try again later.',
          500: 'Internal server error. Please try again later.',
          502: 'Bad gateway. Please try again later.',
          503: 'Service unavailable. Please try again later.',
          504: 'Gateway timeout. Please try again later.',
          520: 'Server error (520). Please try again later.',
          418: 'Request failed (418).',
          null: 'Server returned an invalid response.',
        };

        for (final entry in cases.entries) {
          final result = await errorParser<void>(
            dioException(
              DioExceptionType.badResponse,
              response: dioResponse(
                statusCode: entry.key,
                data: {'message': '   '},
              ),
            ),
          );
          expect((result as Failure<void>).message, entry.value);
        }
      },
    );

    test(
      'falls back to statusCode when response data is non-JSON String',
      () async {
        final result = await errorParser<void>(
          dioException(
            DioExceptionType.badResponse,
            response: dioResponse(
              statusCode: 500,
              data: '<html>Internal Server Error</html>',
            ),
          ),
        );

        expect(
          (result as Failure<void>).message,
          'Internal server error. Please try again later.',
        );
      },
    );

    test(
      'uses statusMessage for unmapped 4xx when API message is absent',
      () async {
        final result = await errorParser<void>(
          dioException(
            DioExceptionType.badResponse,
            response: dioResponse(
              statusCode: 418,
              statusMessage: "I'm a teapot",
            ),
          ),
        );

        expect((result as Failure<void>).message, "I'm a teapot");
      },
    );

    test('handles unknown DioException with inner exceptions', () async {
      final innerCases = <Object, String>{
        const SocketException('Failed host lookup'):
            'No internet connection. Please check your network and try again.',
        TimeoutException('timed out'):
            'Connection timed out. Please try again.',
        const FormatException('bad json'):
            'Invalid response format from server.',
        const HttpException('http fail'): 'HTTP error occurred.',
        const HandshakeException('tls fail'):
            'Secure connection failed. Please try again.',
      };

      for (final entry in innerCases.entries) {
        final result = await errorParser<void>(
          dioException(DioExceptionType.unknown, error: entry.key),
        );
        expect((result as Failure<void>).message, entry.value);
      }
    });

    test(
      'handles unknown DioException with message or empty fallback',
      () async {
        final withMsg = await errorParser<void>(
          dioException(DioExceptionType.unknown, message: 'Custom network msg'),
        );
        expect((withMsg as Failure<void>).message, 'Custom network msg');

        final empty = await errorParser<void>(
          dioException(DioExceptionType.unknown),
        );
        expect(
          (empty as Failure<void>).message,
          'An unexpected network error occurred.',
        );
      },
    );
  });

  group('errorParser - non-Dio Exceptions', () {
    test('handles SocketException', () async {
      final result = await errorParser<void>(
        const SocketException('No route to host'),
      );
      expect(
        (result as Failure<void>).message,
        'No internet connection. Please check your network and try again.',
      );
    });

    test('handles TimeoutException', () async {
      final result = await errorParser<void>(TimeoutException('timeout'));
      expect(
        (result as Failure<void>).message,
        'Request timed out. Please try again.',
      );
    });

    test('handles FormatException', () async {
      final result = await errorParser<void>(const FormatException('bad'));
      expect((result as Failure<void>).message, 'Invalid data format.');
    });

    test('handles HttpException', () async {
      final result = await errorParser<void>(const HttpException('err'));
      expect((result as Failure<void>).message, 'HTTP error occurred.');
    });

    test('handles HandshakeException', () async {
      final result = await errorParser<void>(const HandshakeException('tls'));
      expect(
        (result as Failure<void>).message,
        'Secure connection failed. Please try again.',
      );
    });

    test('handles PlatformException with and without message', () async {
      final withMsg = await errorParser<void>(
        PlatformException(code: 'ERR', message: 'Permission denied'),
      );
      expect((withMsg as Failure<void>).message, 'Permission denied');

      final withoutMsg = await errorParser<void>(
        PlatformException(code: 'ERR'),
      );
      expect(
        (withoutMsg as Failure<void>).message,
        'A platform error occurred.',
      );
    });

    test(
      'handles generic Exception and preserves exception reference',
      () async {
        final ex = Exception('something went wrong');
        final result = await errorParser<void>(ex);

        expect(result, isA<Failure<void>>());
        final failure = result as Failure<void>;
        expect(failure.message, 'An unexpected error occurred.');
        expect(failure.exception, same(ex));
      },
    );
  });
}
