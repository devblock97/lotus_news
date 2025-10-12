import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lotus_news/features/news/data/model/news_model.dart';

abstract class NewsLocalDatasource {
  Future<void> saveNews(List<NewsModel> news) =>
      throw UnimplementedError('Stub');
  Future<List<NewsModel>> retrieveNews() => throw UnimplementedError('Stub');
}

class NewsLocalDataSourceImpl implements NewsLocalDatasource {
  static const String newsKey = 'newsKey';

  @override
  Future<List<NewsModel>> retrieveNews() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String>? newsJsonString = prefs.getStringList(newsKey);
      if (newsJsonString == null || newsJsonString.isEmpty) {
        return [];
      }
      List<NewsModel> news = newsJsonString
          .map((news) => NewsModel.fromJson(jsonDecode(news)))
          .toList();
      return news;
    } catch (e, stackTrace) {
      debugPrint(
        'NewsLocalDataSource [retrieveNews] exception: ${e.toString()}',
      );
      debugPrint('NewsLocalDataSource [retrieveNews] stackTrace: $stackTrace');
      return [];
    }
  }

  @override
  Future<void> saveNews(List<NewsModel> news) async {
    try {
      final pref = await SharedPreferences.getInstance();
      List<String> newsJsonList = news
          .map((n) => jsonEncode(n.toJson()))
          .toList();
      await pref.setStringList(newsKey, newsJsonList);
      debugPrint('trigger saveNews local data source: ${jsonEncode(news)}');
    } catch (e) {
      debugPrint('NewsLocalDataSource [saveNews] exception: ${e.toString()}');
      rethrow;
    }
  }
}
