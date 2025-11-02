import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/constants/app_constants.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/core/network/client.dart';
import 'package:lotus_news/features/news/data/model/news_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsModel>> getNews() => throw UnimplementedError('Stub');
  Future<NewsModel> getNewsById(String id) => throw UnimplementedError('Stub');
  Future<int> voteNews(String newsId) => throw UnimplementedError('Stub');
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Client _client;
  NewsRemoteDataSourceImpl(this._client);

  @override
  Future<List<NewsModel>> getNews() async {
    try {
      final response = await _client.get(AppConstants.posts);
      debugPrint('check response data: ${response.data['posts']}');
      List<NewsModel> data = (response.data['posts'] as List)
          .map((n) => NewsModel.fromJson(n))
          .toList();

      return data;
    } on DioException catch (e) {
      throw Failure.fromNetwork(e);
    }
  }

  @override
  Future<NewsModel> getNewsById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<int> voteNews(String newsId) async {
    try {
      final response = await _client.post(
        AppConstants.voteNews(newsId),
        data: {"user_id": "95a7c9cf-a052-4bfe-bacc-940a0e56040e", "value": 1},
      );
      if (response.statusCode != 200) {
        return 1;
      }
      return 0;
    } on DioException catch (e) {
      throw Left(Failure.fromNetwork(e));
    }
  }
}
