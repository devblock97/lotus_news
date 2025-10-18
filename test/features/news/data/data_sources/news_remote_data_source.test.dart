import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/core/network/client.dart';
import 'package:lotus_news/features/news/data/datasource/news_remote_datasource.dart';
import 'package:lotus_news/features/news/data/model/news_model.dart';
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements Client {}

void main() {
  late NewsRemoteDataSourceImpl remoteDataSource;
  late MockClient mockClientNetwork;

  setUp(() {
    mockClientNetwork = MockClient();
    remoteDataSource = NewsRemoteDataSourceImpl(mockClientNetwork);
  });

  group('getNews', () {
    final tNews = [
      NewsModel(
        id: '1',
        body: 'This is news body 1',
        createdAt: DateTime.now().toIso8601String(),
        score: 10,
        title: 'This is news title 1',
      ),
      NewsModel(
        id: '2',
        body: 'This is news body 2',
        createdAt: DateTime.now().toIso8601String(),
        score: 11,
        title: 'This is news title 2',
      ),
    ];

    final tNewsResponse = [
      NewsModel(
        id: '1',
        body: 'This is news body 1',
        createdAt: DateTime.now().toIso8601String(),
        score: 10,
        title: 'This is news title 1',
      ),
      NewsModel(
        id: '2',
        body: 'This is news body 2',
        createdAt: DateTime.now().toIso8601String(),
        score: 11,
        title: 'This is news title 2',
      ),
    ];

    test('should perform GET request on /news endpoint', () async {
      // arrange
      when(() => mockClientNetwork.get(any())).thenAnswer(
        (_) async => Response(
          data: tNewsResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/news'),
        ),
      );

      // act
      await remoteDataSource.getNews();

      // assert
      verify(() => mockClientNetwork.get('/news')).called(1);
    });

    test(
      'should return a list of News when the response code is 200',
      () async {
        // arrange
        when(() => mockClientNetwork.get(any as String)).thenAnswer(
          (_) async => Response(
            data: {'posts': tNews.map((news) => news.toJson()).toList()},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        // act
        final result = await remoteDataSource.getNews();

        // assert
        expect(result, tNews);
      },
    );

    test('should return list of NewsModel when status code is 200', () async {
      // arrange
      when(() => mockClientNetwork.get(any())).thenAnswer(
        (_) async => Response(
          data: tNewsResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/news'),
        ),
      );

      // act
      final result = await remoteDataSource.getNews();

      // assert
      expect(result, isA<List<NewsModel>>());
      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[0].title, 'This is news title 1');
      expect(result[1].id, '2');
    });

    test(
      'should throw ServerException when DioException with 500 occurs',
      () async {
        // arrange
        when(() => mockClientNetwork.get(any())).thenThrow(
          DioException(
            type: DioExceptionType.badResponse,
            response: Response(
              statusCode: 500,
              requestOptions: RequestOptions(path: '/news'),
            ),
            requestOptions: RequestOptions(path: '/news'),
          ),
        );

        // act & assert
        expect(() => remoteDataSource.getNews(), throwsA(isA<Failure>()));
      },
    );
  });
}
