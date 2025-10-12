import 'package:lotus_news/features/news/data/model/news_model.dart';

sealed class SearchState {
  const SearchState();
}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<NewsModel> data;
  const SearchSuccess({required this.data});
}

class SearchError extends SearchState {
  final String? message;
  final int? code;
  SearchError({this.message, this.code});
}
