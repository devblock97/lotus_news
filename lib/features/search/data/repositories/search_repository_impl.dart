
import 'package:dio/dio.dart';
import 'package:fpdart/src/either.dart';
import 'package:tma_news/core/exceptions/failure.dart';
import 'package:tma_news/features/news/data/model/news_model.dart';
import 'package:tma_news/features/search/data/datasource/search_remote_datasource.dart';
import 'package:tma_news/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {

  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<NewsModel>>> search(String keyword) async {
    try {
      final response = await remoteDataSource.search(keyword);
      return Right(response);
    } on DioException catch (e) {
      return Left(Failure.fromNetwork(e));
    }
  }

}