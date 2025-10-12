import 'package:flutter/widgets.dart';
import 'package:lotus_news/features/assistant/data/model/assistant_request.dart';
import 'package:lotus_news/features/assistant/data/model/assistant_response.dart';
import 'package:lotus_news/features/assistant/domain/usecases/summary_stream_usecase.dart';
import 'package:lotus_news/features/assistant/domain/usecases/summary_usecase.dart';
import 'package:lotus_news/injector.dart';

class AssistantViewModel extends ChangeNotifier {
  final summaryUseCase = injector<SummaryUseCase>();
  final summaryStreamUseCase = injector<SummaryStreamUseCase>();

  SummaryState _state = SummaryInitialize();
  SummaryState get state => _state;

  String _streamedText = '';
  String get streamedText => _streamedText;

  Future<void> summary(String prompt) async {
    _state = SummaryLoading();
    notifyListeners();
    try {
      final String processedPrompt =
          ''
          'Tóm tắt nội dụng này "$prompt" bằng tiếng Việt dưới 5 câu '
          'và không chứa bất kỳ ký tự đặc biệt nào trong nội dụng tóm tắt';
      final AssistantRequest param = AssistantRequest(prompt: processedPrompt);
      final response = await summaryUseCase.call(AssistantParam(param));
      response.fold(
        (error) {
          _state = SummaryError();
          notifyListeners();
        },
        (data) {
          _state = SummarySuccess(data: data);
          notifyListeners();
        },
      );
    } catch (e) {
      _state = SummaryError(message: e.toString());
      rethrow;
    }
  }

  Future<void> summaryStream(String prompt) async {
    _state = SummaryLoading();
    notifyListeners();
    try {
      final String processedPrompt =
          ''
          'Tóm tắt nội dụng này "$prompt" bằng tiếng Việt dưới 5 câu '
          'và không thêm câu "Dưới đây là bản tóm tắt nội dung..."'
          'và không chứa bất kỳ ký tự đặc biệt nào trong nội dụng tóm tắt';
      final AssistantRequest param = AssistantRequest(
        prompt: processedPrompt,
        stream: true,
      );
      final stream = summaryStreamUseCase.call(AssistantParam(param));
      stream.listen(
        (event) {
          event.fold(
            (failure) {
              _state = SummaryError(message: failure.message);
              notifyListeners();
            },
            (chunk) {
              _streamedText += chunk;
              _state = SummaryStreaming(
                data: AssistantResponse(response: _streamedText),
              );
              notifyListeners();
            },
          );
        },
        onDone: () {
          _state = SummaryStreaming(
            data: AssistantResponse(response: _streamedText),
          );
          notifyListeners();
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}

sealed class SummaryState {
  const SummaryState();
}

class SummaryInitialize extends SummaryState {}

class SummaryLoading extends SummaryState {}

class SummarySuccess extends SummaryState {
  final AssistantResponse data;
  const SummarySuccess({required this.data});
}

class SummaryError extends SummaryState {
  final String? message;
  final int? code;
  const SummaryError({this.message, this.code});
}

class SummaryStreaming extends SummaryState {
  final AssistantResponse data;
  const SummaryStreaming({required this.data});
}
