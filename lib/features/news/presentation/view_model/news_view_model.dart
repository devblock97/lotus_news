import 'package:flutter/cupertino.dart';
import 'package:tma_news/core/usecases/usecase.dart';
import 'package:tma_news/features/news/domain/usecases/get_news_by_id_usecase.dart';
import 'package:tma_news/features/news/domain/usecases/get_news_usecase.dart';
import 'package:tma_news/injector.dart';

import 'news_state.dart';

class NewsViewModel extends ChangeNotifier {

  final GetNewsUseCase _getNewsUseCase = GetNewsUseCase(injector());
  final GetNewsByIdUseCase _getNewsByIdUseCase = GetNewsByIdUseCase(injector());

  NewsState _state = NewsLoading();
  NewsState get state => _state;

  Future<void> getNews() async {
    _state = NewsLoading();
    try {
      injector.call<GetNewsUseCase>();
      final response = await _getNewsUseCase.call(NoParams());
      response.fold(
        (error) {
          debugPrint('return left: ${error.message}');
          _state = NewsError(error.message);
        },
        (data) {
          _state = NewsSuccess(data: data);
        }
      );
    } catch (_) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> getNewsById(String id) async {
    _state = NewsByIdLoading();
    try {
      final response = await _getNewsByIdUseCase.call(NewsParam(id: id));
      response.fold(
          (error) {
            _state = NewsByIdError(error.message);
          },
          (news) {
            _state = NewsByIdSuccess(news: news);
          }
      );
    } catch (_) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }
}