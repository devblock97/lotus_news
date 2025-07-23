import 'package:flutter/foundation.dart';
import 'package:tma_news/core/constants/app_constants.dart';
import 'package:tma_news/core/network/client.dart';
import 'package:tma_news/features/news/data/model/news_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<NewsModel>> getNews() => throw UnimplementedError('Stub');
  Future<NewsModel> getNewsById(String id) => throw UnimplementedError('Stub');
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  
  final Client _client;
  NewsRemoteDataSourceImpl(this._client);
  
  @override
  Future<List<NewsModel>> getNews() async {
    try {
      final response = await _client.get(AppConstants.news);
      debugPrint('check response data: ${response.data['news']}');
      List<NewsModel> data = (response.data['news'] as List).map((n) => NewsModel.fromJson(n)).toList();

      return data;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<NewsModel> getNewsById(String id) {
    throw UnimplementedError();
  }
}