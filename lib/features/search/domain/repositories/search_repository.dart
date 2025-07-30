import 'package:fpdart/fpdart.dart';
import 'package:tma_news/core/exceptions/failure.dart';
import 'package:tma_news/features/news/data/model/news_model.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<NewsModel>>> search(String keyword) =>
      throw UnimplementedError('Stub');
}