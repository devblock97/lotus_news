import 'package:flutter/cupertino.dart';
import 'package:lotus_news/core/usecases/usecase.dart';
import 'package:lotus_news/features/news/domain/usecases/get_news_by_id_usecase.dart';
import 'package:lotus_news/features/news/domain/usecases/get_news_usecase.dart';

import 'news_state.dart';

class NewsViewModel extends ChangeNotifier {
  final GetNewsUseCase _getNewsUseCase;
  final GetNewsByIdUseCase _getNewsByIdUseCase;

  NewsViewModel(this._getNewsUseCase, this._getNewsByIdUseCase);

  NewsState _state = NewsInitialize();
  NewsState get state => _state;

  Future<void> getNews() async {
    _state = NewsLoading();
    notifyListeners();
    try {
      final response = await _getNewsUseCase.call(NoParams());
      response.fold(
        (error) {
          debugPrint('return left: ${error.message}');
          _state = NewsError(error.message);
        },
        (data) {
          _state = NewsSuccess(data: data);
        },
      );
      notifyListeners();
    } catch (e) {
      _state = NewsError('Unexpected error: $e');
      notifyListeners();
    }
  }

  Future<void> getNewsById(String id) async {
    _state = NewsByIdLoading();
    notifyListeners();
    try {
      final response = await _getNewsByIdUseCase.call(NewsParam(id: id));
      response.fold(
        (error) {
          _state = NewsByIdError(error.message);
        },
        (news) {
          _state = NewsByIdSuccess(news: news);
        },
      );
      notifyListeners();
    } catch (e) {
      _state = NewsByIdError('Unexpected error: $e');
    } finally {
      notifyListeners();
    }
  }
}
