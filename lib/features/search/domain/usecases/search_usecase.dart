import 'package:fpdart/src/either.dart';
import 'package:tma_news/core/exceptions/failure.dart';
import 'package:tma_news/core/usecases/usecase.dart';
import 'package:tma_news/features/news/data/model/news_model.dart';
import 'package:tma_news/features/search/domain/repositories/search_repository.dart';

class SearchUseCase extends UseCase<List<NewsModel>, SearchParam> {
  final SearchRepository _repository;
  SearchUseCase(this._repository);

  @override
  Future<Either<Failure, List<NewsModel>>> call(SearchParam params) {
    return _repository.search(params.keyword);
  }
}

final class SearchParam {
  final String keyword;
  const SearchParam({required this.keyword});
}