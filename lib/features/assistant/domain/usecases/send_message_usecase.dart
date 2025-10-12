import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/core/usecases/usecase.dart';
import 'package:lotus_news/features/assistant/data/model/assistant_response.dart';
import 'package:lotus_news/features/assistant/domain/repositories/chat_repository.dart';
import 'package:lotus_news/features/assistant/domain/usecases/summary_usecase.dart';

class ChatUseCase extends StreamUseCase<AssistantResponse, AssistantParam> {
  final ChatRepository _repository;
  ChatUseCase(this._repository);

  @override
  Stream<Either<Failure, AssistantResponse>> call(AssistantParam params) {
    return _repository.send(params.param);
  }
}
