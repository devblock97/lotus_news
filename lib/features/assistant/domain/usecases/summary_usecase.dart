import 'package:fpdart/src/either.dart';
import 'package:tma_news/core/exceptions/failure.dart';
import 'package:tma_news/core/usecases/usecase.dart';
import 'package:tma_news/features/assistant/data/model/assistant_request.dart';
import 'package:tma_news/features/assistant/data/model/assistant_response.dart';
import 'package:tma_news/features/assistant/domain/repositories/summary_repository.dart';

class SummaryUseCase extends UseCase<AssistantResponse, GetSummaryParam> {

  final SummaryRepository _repository;
  SummaryUseCase(this._repository);

  @override
  Future<Either<Failure, AssistantResponse>> call(GetSummaryParam params) async {
    return _repository.summarize(params.param);
  }

}

final class GetSummaryParam {
  final AssistantRequest param;
  const GetSummaryParam(this.param);
}