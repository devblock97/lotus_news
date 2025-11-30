import 'package:dio/dio.dart';
import 'package:lotus_news/features/auth/domain/repositories/auth_storage_repository.dart';

class AuthInterceptor extends Interceptor {
  final AuthStorageRepository _authStorageRepository;

  AuthInterceptor({required AuthStorageRepository authStorageRepository})
    : _authStorageRepository = authStorageRepository;

  // Track which requests are currently being retried to prevent infinite loops
  final Set<String> _retryingRequests = <String>{};

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // super.onRequest(options, handler);
    try {
      if (_isAuthEndpoint(options.path)) {
        return handler.next(options);
      }

      final authResult = await _authStorageRepository.getAuthorizationHeader();
      authResult.fold(
        (failure) {
          // Handle failure, maybe log it or just proceed without header
          return handler.next(options);
        },
        (token) {
          if (token != null) {
            options.headers['Authorization'] = token;
          }
          return handler.next(options);
        },
      );
    } catch (e) {
      return handler.next(options);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      if (_isAuthEndpoint(err.requestOptions.path)) {}

      final requestKey =
          '${err.requestOptions.method}_${err.requestOptions.uri}';

      if (_retryingRequests.contains(requestKey)) {
        return handler.next(err);
      }

      try {
        _retryingRequests.add(requestKey);
      } catch (retryError) {
        return handler.next(err);
      } finally {
        _retryingRequests.remove(requestKey);
      }
    }
    return handler.next(err);
  }

  bool _isAuthEndpoint(String path) {
    final authPaths = ['/api/login', '/api/refresh', '/api/logout'];

    return authPaths.any((authPath) => path.contains(authPath));
  }
}
