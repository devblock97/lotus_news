import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'network_error_model.dart';

abstract class OfflineException {}

class CacheException extends OfflineException {}

class RetrieveException extends OfflineException {}

class Failure extends Equatable implements Exception {
  final int? statusCode;
  final String? message;

  const Failure({this.message, this.statusCode});

  factory Failure.fromOffline(OfflineException offlineException) {
    String message;
    switch (offlineException) {
      case CacheException _:
        message = 'Save data to DB is error';
        break;
      case RetrieveException _:
        message = 'Retrieve data from DB is error';
        break;
      default:
        message = 'Unknown offline error';
        break;
    }
    return Failure(message: message);
  }

  factory Failure.fromNetwork(DioException dioException) {
    String message;
    int? statusCode = dioException.response?.statusCode;

    debugPrint('network error: ${dioException.type.toString()}');

    switch (dioException.type) {
      case DioExceptionType.cancel:
        message = 'Request to API server was cancelled';
        break;

      case DioExceptionType.connectionTimeout:
        message = 'Không thể kết nối đến máy chủ. Vui lòng thử lại sau!!';
        break;

      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout in connection with API server';
        break;

      case DioExceptionType.sendTimeout:
        message = 'Send timeout in connection with API server';
        break;

      case DioExceptionType.connectionError:
        if (dioException.error.runtimeType == SocketException) {
          message =
              'Không thể kết nối đến máy chủ. Vui lòng kiểm tra lại internet';
          break;
        } else {
          message = 'Unexpected error occurred';
          break;
        }

      case DioExceptionType.badCertificate:
        message = 'Bad Certificate';
        break;

      case DioExceptionType.badResponse:
        final model = NetworkErrorModel.fromJson(
          dioException.response?.data as Map<String, dynamic>,
        );
        message = model.statusMessage ?? 'Unexpected bad response';
        break;

      case DioExceptionType.unknown:
        message = 'Unexpected error occurred';
        break;
    }
    return Failure(message: message, statusCode: statusCode);
  }

  @override
  List<Object?> get props => [statusCode, message];
}
