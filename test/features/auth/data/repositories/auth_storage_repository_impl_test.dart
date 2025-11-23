import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:lotus_news/features/auth/data/repositories/auth_storage_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  late AuthStorageRepositoryImpl repository;
  late MockAuthLocalDataSource mockAuthLocalDataSource;

  setUp(() {
    mockAuthLocalDataSource = MockAuthLocalDataSource();
    repository = AuthStorageRepositoryImpl(mockAuthLocalDataSource);
  });

  group('getAccessToken', () {
    test(
      'should return access token when local data source returns a token',
      () async {
        // arrange
        when(
          () => mockAuthLocalDataSource.getAccessToken(),
        ).thenAnswer((_) async => 'token');

        // act
        final result = await repository.getAccessToken();

        // assert
        expect(result, const Right('token'));
        verify(() => mockAuthLocalDataSource.getAccessToken());
        verifyNoMoreInteractions(mockAuthLocalDataSource);
      },
    );

    test(
      'should return a failure when local data source returns null',
      () async {
        // arrange
        when(
          () => mockAuthLocalDataSource.getAccessToken(),
        ).thenAnswer((_) async => null);

        // act
        final result = await repository.getAccessToken();

        // assert
        expect(result, isA<Left>());
        verify(() => mockAuthLocalDataSource.getAccessToken());
        verifyNoMoreInteractions(mockAuthLocalDataSource);
      },
    );
  });

  group('getAuthorizationHeader', () {
    test('should throw UnimplementedError', () async {
      // act
      final call = repository.getAuthorizationHeader;

      // assert
      expect(() => call(), throwsA(isA<UnimplementedError>()));
    });
  });
}
