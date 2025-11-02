import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/core/usecases/usecase.dart';
import 'package:lotus_news/features/news/domain/repositories/news_repository.dart';

class VoteNewsUseCase extends UseCase<int, VoteParam> {
  final NewsRepository _repository;
  VoteNewsUseCase(this._repository);

  @override
  Future<Either<Failure, int>> call(VoteParam params) async {
    return _repository.voteNews(params.newsId);
  }
}

final class VoteParam extends Equatable {
  final String newsId;
  const VoteParam({required this.newsId});

  @override
  List<Object?> get props => [newsId];
}
