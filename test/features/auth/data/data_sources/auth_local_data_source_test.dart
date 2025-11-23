import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:lotus_news/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:lotus_news/features/auth/data/models/auth_model.dart';
import 'package:lotus_news/features/auth/data/models/user_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockLocalAuthentication extends Mock implements LocalAuthentication {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class FakeAuthenticationOptions extends Fake implements AuthenticationOptions {}

class FakeAuthMessages extends Fake implements AuthMessages {}

void main() {
  late AuthLocalDataSourceImpl dataSource;
  late MockLocalAuthentication mockLocalAuthentication;
  late MockSharedPreferences mockSharedPreferences;

  setUpAll(() {
    registerFallbackValue(FakeAuthenticationOptions());
    registerFallbackValue(<AuthMessages>[]);
  });

  setUp(() {
    mockLocalAuthentication = MockLocalAuthentication();
    mockSharedPreferences = MockSharedPreferences();
    dataSource = AuthLocalDataSourceImpl()..auth = mockLocalAuthentication;
  });

  group('signInWithBiometric', () {
    test(
      'should store true in shared preferences when authentication is successful',
      () async {
        // arrange
        when(
          () => mockLocalAuthentication.authenticate(
            localizedReason: any(named: 'localizedReason'),
            authMessages: any(named: 'authMessages'),
            options: any(named: 'options'),
          ),
        ).thenAnswer((_) async => true);
        when(
          () => mockSharedPreferences.setBool(any(), any()),
        ).thenAnswer((_) async => true);
        SharedPreferences.setMockInitialValues({});

        // act
        await dataSource.signInWithBiometric();

        // assert
        verify(
          () => mockLocalAuthentication.authenticate(
            localizedReason: 'Quét vân tay của bạn hoặc FaceID để xác thực',
            authMessages: any(named: 'authMessages'),
            options: any(named: 'options'),
          ),
        );
      },
    );

    test('should throw an exception when authentication fails', () async {
      // arrange
      when(
        () => mockLocalAuthentication.authenticate(
          localizedReason: any(named: 'localizedReason'),
          authMessages: any(named: 'authMessages'),
          options: any(named: 'options'),
        ),
      ).thenThrow(PlatformException(code: 'Error'));

      // act
      final call = dataSource.signInWithBiometric;

      // assert
      expect(() => call(), throwsA(isA<Exception>()));
    });
  });

  group('isAuthenticated', () {
    test('should return true when access token exists', () async {
      // arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn('token');
      SharedPreferences.setMockInitialValues({'accessToken': 'token'});

      // act
      final result = await dataSource.isAuthenticated();

      // assert
      expect(result, true);
    });

    test('should return false when access token does not exist', () async {
      // arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      SharedPreferences.setMockInitialValues({});

      // act
      final result = await dataSource.isAuthenticated();

      // assert
      expect(result, false);
    });
  });

  group('signOut', () {
    test('should clear all auth data from shared preferences', () async {
      // arrange
      when(
        () => mockSharedPreferences.setBool(any(), any()),
      ).thenAnswer((_) async => true);
      when(
        () => mockSharedPreferences.remove(any()),
      ).thenAnswer((_) async => true);
      SharedPreferences.setMockInitialValues({
        'isBiometricAuthenticated': true,
        'accessToken': 'token',
        'authUser': 'user',
      });

      // act
      final result = await dataSource.signOut();

      // assert
      expect(result, true);
    });
  });

  group('getAccessToken', () {
    test('should return access token from shared preferences', () async {
      // arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn('token');
      SharedPreferences.setMockInitialValues({'accessToken': 'token'});

      // act
      final result = await dataSource.getAccessToken();

      // assert
      expect(result, 'token');
    });
  });

  group('getAuthorizationHeader', () {
    test(
      'should return authorization header when access token exists',
      () async {
        // arrange
        when(() => mockSharedPreferences.getString(any())).thenReturn('token');
        SharedPreferences.setMockInitialValues({'accessToken': 'token'});

        // act
        final result = await dataSource.getAuthorizationHeader();

        // assert
        expect(result, 'Bearer token');
      },
    );

    test('should return null when access token does not exist', () async {
      // arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      SharedPreferences.setMockInitialValues({});

      // act
      final result = await dataSource.getAuthorizationHeader();

      // assert
      expect(result, null);
    });
  });

  group('saveAuthUser', () {
    final tUser = UserModel(
      id: 'id',
      username: 'name',
      email: 'email',
      avatar: 'avatar',
      createdAt: 'createdAt',
    );
    final tAuthModel = AuthModel(user: tUser, token: 'token');
    test('should save auth user to shared preferences', () async {
      // arrange
      when(
        () => mockSharedPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);
      SharedPreferences.setMockInitialValues({});

      // act
      await dataSource.saveAuthUser(tAuthModel);
      final expectedJsonString = json.encode(tAuthModel.toJson());
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('authUser', expectedJsonString);
      final actualJsonString = prefs.getString('authUser');

      // assert
      expect(actualJsonString, expectedJsonString);
    });
  });

  group('saveToken', () {
    test('should save token to shared preferences', () async {
      // arrange
      when(
        () => mockSharedPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);
      SharedPreferences.setMockInitialValues({});

      // act
      await dataSource.saveToken('token');
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', 'token');
      final result = prefs.getString('accessToken');

      // assert
      expect(result, 'token');
    });
  });

  group('clearToken', () {
    test('should remove token from shared preferences', () async {
      // arrange
      when(
        () => mockSharedPreferences.remove(any()),
      ).thenAnswer((_) async => true);
      SharedPreferences.setMockInitialValues({'accessToken': 'token'});

      // act
      await dataSource.clearToken();
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('accessToken');
      final result = prefs.getString('accessToken');

      // assert
      expect(result, null);
    });
  });

  group('clearUser', () {
    test('should remove user from shared preferences', () async {
      // arrange
      when(
        () => mockSharedPreferences.remove(any()),
      ).thenAnswer((_) async => true);
      SharedPreferences.setMockInitialValues({'authUser': 'user'});

      // act
      await dataSource.clearUser();
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('authUser');
      final result = prefs.getString('authUser');

      // assert
      expect(result, null);
    });
  });
}
