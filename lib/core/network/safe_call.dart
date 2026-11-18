import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:route_ecommerce/core/network/api_result.dart';

/// Executes [call] safely and maps any thrown exception into a [Failure].
Future<Result<T>> safeCall<T>(Future<Result<T>> Function() call) async {
  try {
    return await call();
  } on Exception catch (e) {
    return errorParser<T>(e);
  } catch (_) {
    return Failure<T>('An unexpected error occurred.');
  }
}

/// Parses an [Exception] (including [DioException]s and API error payloads)
/// into a [Failure] with a user-friendly error message.
Future<Result<T>> errorParser<T>(Exception e) async {
  final message = switch (e) {
    DioException() => _parseDioException(e),
    SocketException() =>
      'No internet connection. Please check your network and try again.',
    TimeoutException() => 'Request timed out. Please try again.',
    FormatException() => 'Invalid data format.',
    HttpException() => 'HTTP error occurred.',
    HandshakeException() => 'Secure connection failed. Please try again.',
    PlatformException() => _nonEmptyOr(e.message, 'A platform error occurred.'),
    _ => 'An unexpected error occurred.',
  };

  return Failure<T>(message, exception: e);
}

String _parseDioException(DioException e) {
  return switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout =>
      'Connection timed out. Please try again.',
    DioExceptionType.badCertificate =>
      'Invalid security certificate. Unable to establish a secure connection.',
    DioExceptionType.cancel => 'Request was cancelled.',
    DioExceptionType.connectionError =>
      'No internet connection. Please check your network and try again.',
    DioExceptionType.badResponse => _parseBadResponse(e.response),
    DioExceptionType.unknown => _parseUnknownDioError(e),
  };
}

String _parseBadResponse(Response<dynamic>? response) {
  final apiMessage = _extractApiMessage(response?.data);
  if (apiMessage != null) return apiMessage;

  return _statusCodeMessage(response?.statusCode, response?.statusMessage);
}

String? _extractApiMessage(dynamic data) {
  if (data is Map) {
    final msg = data['message'];
    if (msg is String && msg.trim().isNotEmpty) {
      return msg.trim();
    }
    return null;
  }

  if (data is String && data.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map) {
        final msg = decoded['message'];
        if (msg is String && msg.trim().isNotEmpty) {
          return msg.trim();
        }
      }
    } on FormatException {
      return null;
    }
  }

  return null;
}

String _statusCodeMessage(int? statusCode, String? statusMessage) {
  return switch (statusCode) {
    400 => 'Bad request. Please check your input.',
    401 => 'Unauthorized. Please log in again.',
    403 => 'Access denied. You do not have permission to perform this action.',
    404 => 'Requested resource was not found.',
    408 => 'Request timed out. Please try again.',
    409 => 'Conflict occurred. Please try again.',
    422 => 'Validation failed. Please check your input.',
    429 => 'Too many requests. Please try again later.',
    500 => 'Internal server error. Please try again later.',
    502 => 'Bad gateway. Please try again later.',
    503 => 'Service unavailable. Please try again later.',
    504 => 'Gateway timeout. Please try again later.',
    final code? when code >= 500 =>
      'Server error ($code). Please try again later.',
    final code? when code >= 400 => _nonEmptyOr(
      statusMessage,
      'Request failed ($code).',
    ),
    _ => 'Server returned an invalid response.',
  };
}

String _parseUnknownDioError(DioException e) {
  final inner = e.error;
  if (inner is SocketException) {
    return 'No internet connection. Please check your network and try again.';
  }
  if (inner is TimeoutException) {
    return 'Connection timed out. Please try again.';
  }
  if (inner is FormatException) {
    return 'Invalid response format from server.';
  }
  if (inner is HttpException) {
    return 'HTTP error occurred.';
  }
  if (inner is HandshakeException) {
    return 'Secure connection failed. Please try again.';
  }

  return _nonEmptyOr(e.message, 'An unexpected network error occurred.');
}

String _nonEmptyOr(String? value, String fallback) {
  final trimmed = value?.trim();
  if (trimmed != null && trimmed.isNotEmpty) return trimmed;
  return fallback;
}
