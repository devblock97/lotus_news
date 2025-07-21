import '../../data/model/news_model.dart';

abstract class NewsState {
  const NewsState();
}

final class NewsLoading extends NewsState {
  const NewsLoading();
}

final class NewsSuccess extends NewsState {
  final List<NewsModel> data;
  const NewsSuccess({required this.data});
}

final class NewsError extends NewsState {
  final String? message;
  const NewsError(this.message);
}

final class NewsByIdSuccess extends NewsState {
  final NewsModel news;
  const NewsByIdSuccess({required this.news});
}

final class NewsByIdLoading extends NewsState {
  const NewsByIdLoading();
}

final class NewsByIdError extends NewsState {
  final String? message;
  const NewsByIdError(this.message);
}