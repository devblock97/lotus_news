import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:tma_news/core/network/client.dart';
import 'package:tma_news/core/network/network_info.dart';
import 'package:tma_news/features/news/data/datasource/news_local_datasource.dart';
import 'package:tma_news/features/news/data/datasource/news_remote_datasource.dart';
import 'package:tma_news/features/news/data/repositories/news_repository_impl.dart';
import 'package:tma_news/features/news/domain/repositories/news_repository.dart';
import 'package:tma_news/features/news/domain/usecases/get_news_by_id_usecase.dart';
import 'package:tma_news/features/news/domain/usecases/get_news_usecase.dart';
import 'package:tma_news/features/news/presentation/view_model/news_view_model.dart';

final injector = GetIt.instance;

Future<void> init() async {

  injector
  // Network
  ..registerLazySingleton<Client>(Client.new)

  // ViewModel
  ..registerLazySingleton<NewsViewModel>(() => NewsViewModel())

  // UseCases
  ..registerLazySingleton<GetNewsUseCase>(() => GetNewsUseCase(injector()))
  ..registerLazySingleton<GetNewsByIdUseCase>(() => GetNewsByIdUseCase(injector()))

  // Repositories
  ..registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl(localDataSource: injector(), remoteDataSource: injector(), networkInfo: injector()))

  // Remote DataSource
  ..registerLazySingleton<NewsRemoteDataSource>(() => NewsRemoteDataSourceImpl(injector()))

  // Local DataSource
  ..registerLazySingleton<NewsLocalDatasource>(() => NewsLocalDataSourceImpl())
    
  // Network
  ..registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(injector()))
  ..registerLazySingleton(() => Connectivity());


}