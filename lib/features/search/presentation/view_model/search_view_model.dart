import 'package:flutter/material.dart';
import 'package:tma_news/features/search/domain/usecases/search_usecase.dart';
import 'package:tma_news/features/search/presentation/view_model/search_state.dart';
import 'package:tma_news/injector.dart';

class SearchViewModel extends ChangeNotifier {

  late SearchState _state;
  SearchState get state => _state;

  final searchUseCase = injector<SearchUseCase>();

  Future<void> search(String keyword) async {
    _state = SearchLoading();
    try {
      final response = await searchUseCase.call(SearchParam(keyword: keyword));
      response.fold(
          (error) {
            _state = SearchError(message: error.message);
          },
          (data) {
            _state = SearchSuccess(data: data);
          }
      );
    } catch (e) {
      _state = SearchError();
    } finally {
      notifyListeners();
    }
  }
}