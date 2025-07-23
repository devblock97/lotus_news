import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import 'network_error_model.dart';

abstract class OfflineException {

}

class CacheException extends OfflineException { }

class RetrieveException extends OfflineException { }

class Failure extends Equatable implements Exception {
  late final String message;
  late final int? statusCode;

  Failure.fromOffline(OfflineException offlineException) {
    switch (offlineException) {
      case CacheException _:
        message = 'Save data to DB is error';
        break;
      case RetrieveException _:
        break;
    }
  }

  Failure.fromNetwork(DioException dioException) {
    statusCode = dioException.response?.statusCode;

    switch (dioException.type) {
      case DioExceptionType.cancel:
        message = 'Request to API server was cancelled';
        break;

      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout with API server';
        break;

      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout in connection with API server';
        break;

      case DioExceptionType.sendTimeout:
        message = 'Send timeout in connection with API server';
        break;

      case DioExceptionType.connectionError:
        if (dioException.error.runtimeType == SocketException) {
          message = 'Không thể kết nối đến máy chủ';
          break;
        } else {
          message = 'Unexpected error occurred';
          break;
        }

      case DioExceptionType.badCertificate:
        message = 'Bad Certificate';
        break;

      case DioExceptionType.badResponse:
        final model = NetworkErrorModel.fromJson(dioException.response?.data as Map<String, dynamic>);
        message = model.statusMessage ?? 'Unexpected bad response';
        break;

      case DioExceptionType.unknown:
        message = 'Unexpected error occurred';
        break;
    }
  }

  @override
  List<Object?> get props => [statusCode, message];
}