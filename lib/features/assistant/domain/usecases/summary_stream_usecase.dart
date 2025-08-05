import 'package:fpdart/src/either.dart';
import 'package:tma_news/core/exceptions/failure.dart';
import 'package:tma_news/core/usecases/usecase.dart';
import 'package:tma_news/features/assistant/domain/repositories/summary_repository.dart';
import 'package:tma_news/features/assistant/domain/usecases/summary_usecase.dart';

class SummaryStreamUseCase extends StreamUseCase<String, GetSummaryParam> {
  final SummaryRepository _repository;
  SummaryStreamUseCase(this._repository);

  @override
  Stream<Either<Failure, String>> call(GetSummaryParam params) {
    return _repository.summarizeStream(params.param);
  }

}