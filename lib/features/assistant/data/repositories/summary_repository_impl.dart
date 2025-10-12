import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/features/assistant/data/datasource/remote/assistant_remote_data_source.dart';
import 'package:lotus_news/features/assistant/data/model/assistant_request.dart';

import 'package:lotus_news/features/assistant/data/model/assistant_response.dart';

import '../../domain/repositories/summary_repository.dart';

class SummaryRepositoryImpl implements SummaryRepository {
  final AssistantRemoteDataSource _remoteDataSource;

  SummaryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AssistantResponse>> summarize(
    AssistantRequest param,
  ) async {
    try {
      final response = await _remoteDataSource.summarize(param);
      return Right(response);
    } on DioException catch (e) {
      return Left(Failure.fromNetwork(e));
    }
  }

  @override
  Stream<Either<Failure, String>> summarizeStream(
    AssistantRequest param,
  ) async* {
    try {
      await for (final chunk in _remoteDataSource.summarizeStream(param)) {
        yield Right(chunk);
      }
    } on DioException catch (e) {
      yield Left(Failure.fromNetwork(e));
    }
  }
}
