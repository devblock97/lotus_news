import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/core/usecases/usecase.dart';
import 'package:lotus_news/features/assistant/data/model/chat_message.dart';
import 'package:lotus_news/features/assistant/domain/repositories/chat_repository.dart';

class AddMessageUseCase extends UseCase<void, AddMessageParam> {
  final ChatRepository _repository;
  AddMessageUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(AddMessageParam params) async {
    return _repository.add(params.message);
  }
}

class AddMessageParam {
  final ChatMessage message;
  AddMessageParam(this.message);
}
