import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/network/network_info.dart';
import 'package:lotus_news/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:lotus_news/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:lotus_news/features/auth/data/models/auth_model.dart';
import 'package:lotus_news/features/auth/data/models/user_model.dart';
import 'package:lotus_news/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthLocalDataSource mockAuthLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late MockAuthRemoteDataSource mockAuthRemoteDataSource;

  setUp(() {
    mockAuthLocalDataSource = MockAuthLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(
      mockNetworkInfo,
      mockAuthRemoteDataSource,
      mockAuthLocalDataSource,
    );
  });

  group('isAuthenticated', () {
    test('should return true from local data source', () async {
      // arrange
      when(
        () => mockAuthLocalDataSource.isAuthenticated(),
      ).thenAnswer((_) async => true);

      // act
      final result = await repository.isAuthenticated();

      // assert
      expect(result, const Right(true));
      verify(() => mockAuthLocalDataSource.isAuthenticated());
      verifyNoMoreInteractions(mockAuthLocalDataSource);
    });

    test(
      'should return a failure when local data source throws an exception',
      () async {
        // arrange
        when(
          () => mockAuthLocalDataSource.isAuthenticated(),
        ).thenThrow(Exception());

        // act
        final result = await repository.isAuthenticated();

        // assert
        expect(result, isA<Left>());
        verify(() => mockAuthLocalDataSource.isAuthenticated());
        verifyNoMoreInteractions(mockAuthLocalDataSource);
      },
    );
  });

  group('signIn', () {
    const tEmail = 'email';
    const tPassword = 'password';
    final tUser = UserModel(
      id: 'id',
      username: 'name',
      email: 'email',
      avatar: 'avatar',
      createdAt: 'createdAt',
    );
    final tAuthModel = AuthModel(user: tUser, token: 'token');

    test('should return auth model when sign in is successful', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockAuthRemoteDataSource.signIn(tEmail, tPassword),
      ).thenAnswer((_) async => tAuthModel);
      when(
        () => mockAuthLocalDataSource.saveAuthUser(tAuthModel),
      ).thenAnswer((_) async => unit);
      when(
        () => mockAuthLocalDataSource.saveToken(tAuthModel.token),
      ).thenAnswer((_) async => unit);
      when(
        () => mockAuthLocalDataSource.isAuthenticated(),
      ).thenAnswer((_) async => true);

      // act
      final result = await repository.signIn(tEmail, tPassword);

      // assert
      expect(result, Right(tAuthModel));
      verify(() => mockNetworkInfo.isConnected);
      verify(() => mockAuthRemoteDataSource.signIn(tEmail, tPassword));
      verify(() => mockAuthLocalDataSource.saveAuthUser(tAuthModel));
      verify(() => mockAuthLocalDataSource.saveToken(tAuthModel.token));
      verify(() => mockAuthLocalDataSource.isAuthenticated());
      verifyNoMoreInteractions(mockAuthRemoteDataSource);
      verifyNoMoreInteractions(mockAuthLocalDataSource);
    });

    test(
      'should return a failure when there is no internet connection',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        // act
        final result = await repository.signIn(tEmail, tPassword);

        // assert
        expect(result, isA<Left>());
        verify(() => mockNetworkInfo.isConnected);
        verifyNoMoreInteractions(mockNetworkInfo);
      },
    );

    test(
      'should return a failure when remote data source throws a DioException',
      () async {
        // arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockAuthRemoteDataSource.signIn(tEmail, tPassword),
        ).thenThrow(DioException(requestOptions: RequestOptions()));

        // act
        final result = await repository.signIn(tEmail, tPassword);

        // assert
        expect(result, isA<Left>());
        verify(() => mockNetworkInfo.isConnected);
        verify(() => mockAuthRemoteDataSource.signIn(tEmail, tPassword));
        verifyNoMoreInteractions(mockAuthRemoteDataSource);
      },
    );
  });

  group('signOut', () {
    test('should return true when sign out is successful', () async {
      // arrange
      when(
        () => mockAuthLocalDataSource.signOut(),
      ).thenAnswer((_) async => true);

      // act
      final result = await repository.signOut();

      // assert
      expect(result, const Right(true));
      verify(() => mockAuthLocalDataSource.signOut());
      verifyNoMoreInteractions(mockAuthLocalDataSource);
    });

    test(
      'should return a failure when local data source throws an exception',
      () async {
        // arrange
        when(() => mockAuthLocalDataSource.signOut()).thenThrow(Exception());

        // act
        final result = await repository.signOut();

        // assert
        expect(result, isA<Left>());
        verify(() => mockAuthLocalDataSource.signOut());
        verifyNoMoreInteractions(mockAuthLocalDataSource);
      },
    );
  });

  group('signInWithBiometrics', () {
    test(
      'should return void when sign in with biometrics is successful',
      () async {
        // arrange
        when(
          () => mockAuthLocalDataSource.signInWithBiometric(),
        ).thenAnswer((_) async => unit);

        // act
        final result = await repository.signInWithBiometrics();

        // assert
        expect(result, const Right(unit));
        verify(() => mockAuthLocalDataSource.signInWithBiometric());
        verifyNoMoreInteractions(mockAuthLocalDataSource);
      },
    );

    test('should rethrow when local data source throws an exception', () async {
      // arrange
      when(
        () => mockAuthLocalDataSource.signInWithBiometric(),
      ).thenThrow(Exception());

      // act
      final call = repository.signInWithBiometrics;

      // assert
      expect(() => call(), throwsA(isA<Exception>()));
      verify(() => mockAuthLocalDataSource.signInWithBiometric());
      verifyNoMoreInteractions(mockAuthLocalDataSource);
    });
  });
}
