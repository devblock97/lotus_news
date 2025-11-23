import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotus_news/core/constants/app_constants.dart';
import 'package:lotus_news/core/network/client.dart';
import 'package:lotus_news/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:lotus_news/features/auth/data/models/auth_model.dart';
import 'package:lotus_news/features/auth/data/models/user_model.dart';
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements Client {}

void main() {
  late AuthRemoteDataSourceImpl remoteDataSource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    remoteDataSource = AuthRemoteDataSourceImpl(mockClient);
  });

  group('signIn', () {
    final tEmail = 'user@gmail.com';
    final tPassword = '123456789';

    final userModel = UserModel(
      avatar: 'https://avatar.com',
      createdAt: DateTime.now().toIso8601String(),
      email: 'user@gmail.com',
      id: '1',
      username: 'username',
    );
    final authModel = AuthModel(token: 'token', user: userModel);

    final tAuthResponse = {
      'token': 'token',
      'user': {
        'id': '1',
        'email': 'user@gmail.com',
        'username': 'username',
        'avatar': 'https://avatar.com',
        'created_at': userModel.createdAt,
      },
    };

    test(
      'should perform POST request with correct endpoint and data',
      () async {
        // Arrange
        when(() => mockClient.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: tAuthResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: AppConstants.login),
          ),
        );

        // Action
        await remoteDataSource.signIn(tEmail, tPassword);

        // Assert
        verify(
          () => mockClient.post(
            AppConstants.login,
            data: {'email': tEmail, 'password': tPassword},
          ),
        ).called(1);
      },
    );

    test(
      'should return AuthModel when the response code is 200 (success)',
      () async {
        // Arrange
        when(() => mockClient.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: tAuthResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: AppConstants.login),
          ),
        );

        // Action
        final result = await remoteDataSource.signIn(tEmail, tPassword);

        // Assert
        expect(result, authModel);
      },
    );

    test(
      'should throw an Exception when the response code is not 200',
      () async {
        // Arrange
        when(() => mockClient.post(any(), data: any(named: 'data'))).thenAnswer(
          (_) async => Response(
            data: 'Something went wrong',
            statusCode: 400,
            requestOptions: RequestOptions(path: AppConstants.login),
          ),
        );

        // Action
        final call = remoteDataSource.signIn(tEmail, tPassword);

        // Assert
        expect(() => call, throwsA(isA<Exception>()));
      },
    );

    test('should throw an Exception when a DioException occurs', () async {
      // Arrange
      when(() => mockClient.post(any(), data: any(named: 'data'))).thenThrow(
        DioException(requestOptions: RequestOptions(path: AppConstants.login)),
      );

      // Action
      final call = remoteDataSource.signIn(tEmail, tPassword);

      // Assert
      expect(() => call, throwsA(isA<Exception>()));
    });
  });
}
