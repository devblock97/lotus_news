import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/core/usecases/usecase.dart';
import 'package:lotus_news/features/news/data/model/news_model.dart';
import 'package:lotus_news/features/news/domain/repositories/news_repository.dart';

class GetNewsByIdUseCase extends UseCase<NewsModel, NewsParam> {
  final NewsRepository _repository;
  GetNewsByIdUseCase(this._repository);

  @override
  Future<Either<Failure, NewsModel>> call(NewsParam params) async {
    return await _repository.getNewsById(params.id);
  }
}

class NewsParam extends Equatable {
  final String id;
  const NewsParam({required this.id});

  @override
  List<Object?> get props => [id];
}
