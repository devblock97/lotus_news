import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/features/assistant/data/datasource/local/chat_local_data_source.dart';
import 'package:lotus_news/features/assistant/data/datasource/remote/chat_remote_data_source.dart';
import 'package:lotus_news/features/assistant/data/model/assistant_request.dart';
import 'package:lotus_news/features/assistant/data/model/assistant_response.dart';
import 'package:lotus_news/features/assistant/data/model/chat_message.dart';
import 'package:lotus_news/features/assistant/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;
  final ChatLocalDataSource _localDataSource;
  ChatRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Stream<Either<Failure, String>> receive(AssistantResponse data) {
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, AssistantResponse>> send(
    AssistantRequest param,
  ) async* {
    try {
      await for (final chunk in _remoteDataSource.send(param)) {
        yield Right(
          AssistantResponse(response: chunk.response, done: chunk.done),
        );
      }
    } on DioException catch (e) {
      yield Left(Failure.fromNetwork(e));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> merge() async {
    await _localDataSource.retrieve();
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> add(ChatMessage message) async {
    try {
      return Right(_localDataSource.addMessage(message));
    } catch (e) {
      rethrow;
    }
  }
}
