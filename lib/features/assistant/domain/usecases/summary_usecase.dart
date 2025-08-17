import 'package:fpdart/src/either.dart';
import 'package:tma_news/core/exceptions/failure.dart';
import 'package:tma_news/core/usecases/usecase.dart';
import 'package:tma_news/features/assistant/data/model/assistant_request.dart';
import 'package:tma_news/features/assistant/data/model/assistant_response.dart';
import 'package:tma_news/features/assistant/domain/repositories/summary_repository.dart';

class SummaryUseCase extends UseCase<AssistantResponse, AssistantParam> {

  final SummaryRepository _repository;
  SummaryUseCase(this._repository);

  @override
  Future<Either<Failure, AssistantResponse>> call(AssistantParam params) async {
    return _repository.summarize(params.param);
  }

}

final class AssistantParam {
  final AssistantRequest param;
  const AssistantParam(this.param);
}