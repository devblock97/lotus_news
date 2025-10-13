import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotus_news/core/network/client.dart';
import 'package:lotus_news/features/news/data/datasource/news_remote_datasource.dart';
import 'package:lotus_news/features/news/data/model/news_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'news_remote_data_source.test.mocks.dart';

@GenerateMocks([Client])
void main() {
  late NewsRemoteDataSourceImpl remoteDataSource;
  late MockClient mockClientNetwork;

  setUp(() {
    mockClientNetwork = MockClient();
    remoteDataSource = NewsRemoteDataSourceImpl(mockClientNetwork);
  });

  group('getPost', () {
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

    test(
      'should return a list of News when the response code is 200',
      () async {
        // arrange
        when(mockClientNetwork.get(any)).thenAnswer(
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
  });
}
