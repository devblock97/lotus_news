import 'package:fpdart/fpdart.dart';
import 'package:lotus_news/core/exceptions/failure.dart';
import 'package:lotus_news/core/usecases/usecase.dart';
import 'package:lotus_news/features/news/data/model/news_model.dart';
import 'package:lotus_news/features/news/domain/repositories/news_repository.dart';

class GetNewsUseCase implements UseCase<List<NewsModel>, NoParams> {
  final NewsRepository _repository;

  GetNewsUseCase(this._repository);

  @override
  Future<Either<Failure, List<NewsModel>>> call(NoParams param) async {
    return await _repository.getNews();
  }
}
