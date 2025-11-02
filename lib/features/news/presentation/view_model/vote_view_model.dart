import 'package:flutter/cupertino.dart';
import 'package:lotus_news/features/news/domain/usecases/vote_news_usecase.dart';
import 'package:lotus_news/features/news/presentation/view_model/vote_state.dart';

class VoteViewModel extends ChangeNotifier {
  final VoteNewsUseCase _voteNewsUseCase;
  VoteViewModel(this._voteNewsUseCase);

  VoteState _state = VoteInitializeState();

  VoteState get state => _state;

  Future<void> voteNews(String newsId) async {
    _state = VoteLoading();
    notifyListeners();
    try {
      final response = await _voteNewsUseCase.call(VoteParam(newsId: newsId));
      response.fold(
        (error) {
          _state = VoteError(message: error.message, code: error.statusCode);
        },
        (value) {
          _state = VoteSuccess(value);
        },
      );
      notifyListeners();
    } catch (e) {
      _state = VoteError(message: e.toString());
      notifyListeners();
    }
  }
}
