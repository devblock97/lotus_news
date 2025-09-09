import 'package:fpdart/src/either.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/core/usecases/usecase.dart';
import 'package:lotus_news/features/assistant/domain/repositories/summary_repository.dart';
import 'package:lotus_news/features/assistant/domain/usecases/summary_usecase.dart';

class SummaryStreamUseCase extends StreamUseCase<String, AssistantParam> {
  final SummaryRepository _repository;
  SummaryStreamUseCase(this._repository);

  @override
  Stream<Either<Failure, String>> call(AssistantParam params) {
    return _repository.summarizeStream(params.param);
  }

}