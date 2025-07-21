import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tma_news/core/exceptions/failure.dart';
import 'package:tma_news/core/network/network_info.dart';
import 'package:tma_news/features/news/data/datasource/news_local_datasource.dart';
import 'package:tma_news/features/news/data/datasource/news_remote_datasource.dart';
import 'package:tma_news/features/news/data/model/news_model.dart';
import 'package:tma_news/features/news/domain/repositories/news_repository.dart';
import 'dart:developer' as developer;

class NewsRepositoryImpl implements NewsRepository {

  final NewsLocalDatasource localDataSource;
  final NewsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const NewsRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo
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

}