import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/network/auth_interceptor.dart';
import 'package:lotus_news/features/auth/domain/repositories/auth_storage_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthStorageRepository extends Mock implements AuthStorageRepository {}

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class MockRequestOptions extends Mock implements RequestOptions {}

class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  late AuthInterceptor authInterceptor;
  late MockAuthStorageRepository mockAuthStorageRepository;
  late MockRequestInterceptorHandler mockRequestInterceptorHandler;
  late RequestOptions mockRequestOptions;

  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
  });

  setUp(() {
    mockAuthStorageRepository = MockAuthStorageRepository();
    authInterceptor = AuthInterceptor(
      authStorageRepository: mockAuthStorageRepository,
    );
    mockRequestInterceptorHandler = MockRequestInterceptorHandler();
    mockRequestOptions = RequestOptions(path: '');
  });

  group('AuthInterceptor', () {
    const tToken = 'test_token';
    const tAuthHeader = 'Bearer $tToken';

    test(
      'should add authorization header when token is available and endpoint is not an auth endpoint',
      () async {
        // arrange
        mockRequestOptions.path = '/api/some_endpoint';
        when(
          () => mockAuthStorageRepository.getAuthorizationHeader(),
        ).thenAnswer((_) async => const Right(tAuthHeader));
        when(
          () => mockRequestInterceptorHandler.next(any()),
        ).thenAnswer((_) {});

        // act
        authInterceptor.onRequest(
          mockRequestOptions,
          mockRequestInterceptorHandler,
        );

        // assert
        await untilCalled(
          () => mockRequestInterceptorHandler.next(mockRequestOptions),
        );
        expect(mockRequestOptions.headers['Authorization'], tAuthHeader);
        verify(
          () => mockRequestInterceptorHandler.next(mockRequestOptions),
        ).called(1);
      },
    );

    test(
      'should not add authorization header when token is not available and endpoint is not an auth endpoint',
      () async {
        // arrange
        mockRequestOptions.path = '/api/some_endpoint';
        when(
          () => mockAuthStorageRepository.getAuthorizationHeader(),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockRequestInterceptorHandler.next(any()),
        ).thenAnswer((_) {});

        // act
        authInterceptor.onRequest(
          mockRequestOptions,
          mockRequestInterceptorHandler,
        );

        // assert
        await untilCalled(
          () => mockRequestInterceptorHandler.next(mockRequestOptions),
        );
        expect(mockRequestOptions.headers['Authorization'], isNull);
        verify(
          () => mockRequestInterceptorHandler.next(mockRequestOptions),
        ).called(1);
      },
    );

    test('should not get token for auth endpoints', () async {
      // arrange
      mockRequestOptions.path = '/api/login';
      when(() => mockRequestInterceptorHandler.next(any())).thenAnswer((_) {});

      // act
      authInterceptor.onRequest(
        mockRequestOptions,
        mockRequestInterceptorHandler,
      );

      // assert
      await untilCalled(
        () => mockRequestInterceptorHandler.next(mockRequestOptions),
      );
      verifyNever(() => mockAuthStorageRepository.getAuthorizationHeader());
      verify(
        () => mockRequestInterceptorHandler.next(mockRequestOptions),
      ).called(1);
    });
  });
}
