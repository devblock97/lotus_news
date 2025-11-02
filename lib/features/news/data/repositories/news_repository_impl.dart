import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/core/network/network_info.dart';
import 'package:lotus_news/features/news/data/datasource/news_local_datasource.dart';
import 'package:lotus_news/features/news/data/datasource/news_remote_datasource.dart';
import 'package:lotus_news/features/news/data/model/news_model.dart';
import 'package:lotus_news/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsLocalDatasource localDataSource;
  final NewsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const NewsRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<NewsModel>>> getNews() async {
    try {
      if (await networkInfo.isConnected) {
        final response = await remoteDataSource.getNews();
        localDataSource.saveNews(response);
        return Right(response);
      } else {
        final news = await localDataSource.retrieveNews();
        return Right(news);
      }
    } on DioException catch (e) {
      return Left(Failure.fromNetwork(e));
    }
  }

  @override
  Future<Either<Failure, NewsModel>> getNewsById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>> voteNews(String newsId) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.voteNews(newsId);
        return Right(1);
      }

      throw Exception();
    } on DioException catch (e) {
      return Left(Failure.fromNetwork(e));
    }
  }
}
