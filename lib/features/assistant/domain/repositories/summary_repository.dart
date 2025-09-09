import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/features/assistant/data/model/assistant_request.dart';
import 'package:lotus_news/features/assistant/data/model/assistant_response.dart';

abstract class SummaryRepository {
  Future<Either<Failure, AssistantResponse>> summarize(AssistantRequest param) =>
      throw UnimplementedError('Stub');

  Stream<Either<Failure, String>> summarizeStream(AssistantRequest param) =>
      throw UnimplementedError('Stub');
}