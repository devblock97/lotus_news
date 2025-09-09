import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/features/news/data/model/news_model.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<NewsModel>>> getNews() =>
      throw UnimplementedError('Stub');
  Future<Either<Failure, NewsModel>> getNewsById(String id) =>
      throw UnimplementedError('Stub');
}