import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:tma_news/core/network/client.dart';
import 'package:tma_news/core/network/network_info.dart';
import 'package:tma_news/features/assistant/data/datasource/remote/assistant_remote_data_source.dart';
import 'package:tma_news/features/assistant/data/repositories/summary_repository.dart';
import 'package:tma_news/features/assistant/domain/repositories/summary_repository.dart';
import 'package:tma_news/features/assistant/domain/usecases/summary_stream_usecase.dart';
import 'package:tma_news/features/assistant/domain/usecases/summary_usecase.dart';
import 'package:tma_news/features/assistant/presentation/view_model/assistant_view_model.dart';
import 'package:tma_news/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:tma_news/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tma_news/features/auth/domain/repositories/auth_repository.dart';
import 'package:tma_news/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:tma_news/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:tma_news/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:tma_news/features/news/data/datasource/news_local_datasource.dart';
import 'package:tma_news/features/news/data/datasource/news_remote_datasource.dart';
import 'package:tma_news/features/news/data/repositories/news_repository_impl.dart';
import 'package:tma_news/features/news/domain/repositories/news_repository.dart';
import 'package:tma_news/features/news/domain/usecases/get_news_by_id_usecase.dart';
import 'package:tma_news/features/news/domain/usecases/get_news_usecase.dart';
import 'package:tma_news/features/news/presentation/view_model/news_view_model.dart';
import 'package:tma_news/features/search/data/datasource/search_remote_datasource.dart';
import 'package:tma_news/features/search/data/repositories/search_repository_impl.dart';
import 'package:tma_news/features/search/domain/repositories/search_repository.dart';
import 'package:tma_news/features/search/domain/usecases/search_usecase.dart';
import 'package:tma_news/features/search/presentation/view_model/search_view_model.dart';

import 'features/news/presentation/view_model/news_voice_view_model.dart';

final injector = GetIt.instance;

Future<void> init() async {

  injector
  // Network
  ..registerLazySingleton<Client>(Client.new)

  // ViewModel
  ..registerLazySingleton<NewsViewModel>(() => NewsViewModel())
  ..registerLazySingleton<SearchViewModel>(() => SearchViewModel())
  ..registerLazySingleton<AuthViewModel>(() => AuthViewModel())
  ..registerLazySingleton<NewsVoiceViewModel>(() => NewsVoiceViewModel())
  ..registerLazySingleton<AssistantViewModel>(() => AssistantViewModel())

  // UseCases
  ..registerLazySingleton<GetNewsUseCase>(() => GetNewsUseCase(injector()))
  ..registerLazySingleton<GetNewsByIdUseCase>(() => GetNewsByIdUseCase(injector()))
  ..registerLazySingleton<SearchUseCase>(() => SearchUseCase(injector()))
  ..registerLazySingleton<SignInUseCase>(() => SignInUseCase(injector()))
  ..registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(injector()))
  ..registerLazySingleton<SummaryUseCase>(() => SummaryUseCase(injector()))
  ..registerLazySingleton<SummaryStreamUseCase>(() => SummaryStreamUseCase(injector()))

  // Repositories
  ..registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl(localDataSource: injector(), remoteDataSource: injector(), networkInfo: injector()))
  ..registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(injector()))
  ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(injector()))
  ..registerLazySingleton<SummaryRepository>(() => SummaryRepositoryImpl(injector()))

  // Remote DataSource
  ..registerLazySingleton<NewsRemoteDataSource>(() => NewsRemoteDataSourceImpl(injector()))
  ..registerLazySingleton<SearchRemoteDataSource>(() => SearchRemoteDataSourceImpl(injector()))
  ..registerLazySingleton<AssistantRemoteDataSource>(() => AssistantRemoteDataSourceImpl(injector()))

  // Local DataSource
  ..registerLazySingleton<NewsLocalDatasource>(() => NewsLocalDataSourceImpl())
  ..registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl())
    
  // Network
  ..registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(injector()))
  ..registerLazySingleton(() => Connectivity());


}