
import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/features/assistant/data/model/assistant_request.dart';
import 'package:lotus_news/features/assistant/data/model/assistant_response.dart';
import 'package:lotus_news/features/assistant/data/model/chat_message.dart';

abstract class ChatRepository {
  Stream<Either<Failure, AssistantResponse>> send(AssistantRequest param) =>
      throw UnimplementedError('Stub');

  Stream<Either<Failure, String>> receive(AssistantResponse data) =>
      throw UnimplementedError('Stub');

  Future<Either<Failure, void>> add(ChatMessage message) =>
      throw UnimplementedError('Stub');

  Future<Either<Failure, List<ChatMessage>>> merge() =>
      throw UnimplementedError('Stub');
}