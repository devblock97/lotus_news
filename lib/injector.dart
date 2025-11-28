import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:lotus_news/core/network/auth_interceptor.dart';
import 'package:lotus_news/core/network/client.dart';
import 'package:lotus_news/core/network/network_info.dart';
import 'package:lotus_news/features/assistant/data/datasource/local/chat_local_data_source.dart';
import 'package:lotus_news/features/assistant/data/datasource/remote/assistant_remote_data_source.dart';
import 'package:lotus_news/features/assistant/data/datasource/remote/chat_remote_data_source.dart';
import 'package:lotus_news/features/assistant/data/repositories/chat_repository_impl.dart';
import 'package:lotus_news/features/assistant/data/repositories/summary_repository_impl.dart';
import 'package:lotus_news/features/assistant/domain/repositories/chat_repository.dart';
import 'package:lotus_news/features/assistant/domain/repositories/summary_repository.dart';
import 'package:lotus_news/features/assistant/domain/usecases/add_message_usecase.dart';
import 'package:lotus_news/features/assistant/domain/usecases/send_message_usecase.dart';
import 'package:lotus_news/features/assistant/domain/usecases/summary_stream_usecase.dart';
import 'package:lotus_news/features/assistant/domain/usecases/summary_usecase.dart';
import 'package:lotus_news/features/assistant/presentation/view_model/assistant_view_model.dart';
import 'package:lotus_news/features/assistant/presentation/view_model/chat_view_model.dart';
import 'package:lotus_news/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:lotus_news/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:lotus_news/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lotus_news/features/auth/data/repositories/auth_storage_repository_impl.dart';
import 'package:lotus_news/features/auth/domain/repositories/auth_repository.dart';
import 'package:lotus_news/features/auth/domain/repositories/auth_storage_repository.dart';
import 'package:lotus_news/features/auth/domain/usecases/authenticated_usecase.dart';
import 'package:lotus_news/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:lotus_news/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:lotus_news/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:lotus_news/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:lotus_news/features/news/data/datasource/news_local_datasource.dart';
import 'package:lotus_news/features/news/data/datasource/news_remote_datasource.dart';
import 'package:lotus_news/features/news/data/repositories/news_repository_impl.dart';
import 'package:lotus_news/features/news/domain/repositories/news_repository.dart';
import 'package:lotus_news/features/news/domain/usecases/get_news_by_id_usecase.dart';
import 'package:lotus_news/features/news/domain/usecases/get_news_usecase.dart';
import 'package:lotus_news/features/news/domain/usecases/vote_news_usecase.dart';
import 'package:lotus_news/features/news/presentation/view_model/news_view_model.dart';
import 'package:lotus_news/features/news/presentation/view_model/vote_view_model.dart';
import 'package:lotus_news/features/search/data/datasource/search_remote_datasource.dart';
import 'package:lotus_news/features/search/data/repositories/search_repository_impl.dart';
import 'package:lotus_news/features/search/domain/repositories/search_repository.dart';
import 'package:lotus_news/features/search/domain/usecases/search_usecase.dart';
import 'package:lotus_news/features/search/presentation/view_model/search_view_model.dart';

import 'features/news/presentation/view_model/news_voice_view_model.dart';

final injector = GetIt.instance;

Future<void> init() async {
  injector
    // Network
    ..registerLazySingleton<AuthStorageRepository>(
      () => AuthStorageRepositoryImpl(injector()),
    )
    ..registerLazySingleton(
      () => AuthInterceptor(authStorageRepository: injector()),
    )
    ..registerLazySingleton<Client>(() => Client(authInterceptor: injector()))
    // ViewModel
    ..registerLazySingleton<NewsViewModel>(
      () => NewsViewModel(injector(), injector()),
    )
    ..registerLazySingleton<SearchViewModel>(() => SearchViewModel())
    ..registerLazySingleton<AuthViewModel>(
      () => AuthViewModel(injector(), injector(), injector(), injector()),
    )
    ..registerLazySingleton<NewsVoiceViewModel>(() => NewsVoiceViewModel())
    ..registerLazySingleton<AssistantViewModel>(() => AssistantViewModel())
    ..registerLazySingleton<ChatViewModel>(() => ChatViewModel())
    ..registerLazySingleton<VoteViewModel>(() => VoteViewModel(injector()))
    // UseCases
    ..registerLazySingleton<GetNewsUseCase>(() => GetNewsUseCase(injector()))
    ..registerLazySingleton<GetNewsByIdUseCase>(
      () => GetNewsByIdUseCase(injector()),
    )
    ..registerLazySingleton<SearchUseCase>(() => SearchUseCase(injector()))
    ..registerLazySingleton<SignInUseCase>(() => SignInUseCase(injector()))
    ..registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(injector()))
    ..registerLazySingleton<ChangePasswordUseCase>(
      () => ChangePasswordUseCase(injector()),
    )
    ..registerLazySingleton<AuthenticatedUseCase>(
      () => AuthenticatedUseCase(injector()),
    )
    ..registerLazySingleton<SummaryUseCase>(() => SummaryUseCase(injector()))
    ..registerLazySingleton<SummaryStreamUseCase>(
      () => SummaryStreamUseCase(injector()),
    )
    ..registerLazySingleton<ChatUseCase>(() => ChatUseCase(injector()))
    ..registerLazySingleton<AddMessageUseCase>(
      () => AddMessageUseCase(injector()),
    )
    ..registerLazySingleton<VoteNewsUseCase>(() => VoteNewsUseCase(injector()))
    // Repositories
    ..registerLazySingleton<NewsRepository>(
      () => NewsRepositoryImpl(
        localDataSource: injector(),
        remoteDataSource: injector(),
        networkInfo: injector(),
      ),
    )
    ..registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(injector()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(injector(), injector(), injector()),
    )
    ..registerLazySingleton<SummaryRepository>(
      () => SummaryRepositoryImpl(injector()),
    )
    ..registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(injector(), injector()),
    )
    // Remote DataSource
    ..registerLazySingleton<NewsRemoteDataSource>(
      () => NewsRemoteDataSourceImpl(injector()),
    )
    ..registerLazySingleton<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(injector()),
    )
    ..registerLazySingleton<AssistantRemoteDataSource>(
      () => AssistantRemoteDataSourceImpl(injector()),
    )
    ..registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(injector()),
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(injector()),
    )
    // Local DataSource
    ..registerLazySingleton<NewsLocalDatasource>(
      () => NewsLocalDataSourceImpl(),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(),
    )
    ..registerLazySingleton<ChatLocalDataSource>(
      () => ChatLocalDataSourceImpl(),
    )
    // Network
    ..registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(injector()))
    ..registerLazySingleton(() => Connectivity());
}
