import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lotus_news/features/news/data/model/news_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNews = NewsModel(
    id: "ce66daff-1d01-484c-98de-1b054b3c2938",
    title: "This is title post 49",
    thumbnail: "https://url.example.com",
    body: "This is body post 49",
    content: Content(rendered: 'rendered', protected: false),
    shortDescription: "This is short description post 49",
    score: 0,
    createdAt: "2025-10-10T16:43:02.204003Z",
    avatar: "https://url.avatar.com",
  );

  test('should be a subclass of News entity', () async {
    expect(tNews, isA<NewsModel>());
  });

  group('fromJson', () {
    test('should return valid model when JSON is a News', () async {
      // arrange
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('news.json'));

      // act
      final result = NewsModel.fromJson(jsonMap);

      // assert
      expect(result, tNews);
    });
  });

  group('toJson', () {
    test('should return a valid model when toJson is Post', () async {
      // arrange
      final result = tNews.toJson();

      // action
      final expectedResult = {"id": "ce66daff-1d01-484c-98de-1b054b3c2938"};

      // assert
      expect(result, expectedResult);
    });
  });
}
