
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tma_news/features/assistant/data/model/assistant_request.dart';
import 'package:tma_news/features/assistant/data/model/assistant_response.dart';
import 'package:tma_news/features/assistant/domain/usecases/add_message_usecase.dart';
import 'package:tma_news/features/assistant/domain/usecases/send_message_usecase.dart';
import 'package:tma_news/features/assistant/domain/usecases/summary_usecase.dart';
import 'package:tma_news/injector.dart';
import 'package:tma_news/features/assistant/data/model/chat_message.dart';

class ChatViewModel extends ChangeNotifier {

  final ChatUseCase _chatUseCase = injector<ChatUseCase>();
  final AddMessageUseCase _addMessageUseCase = injector<AddMessageUseCase>();

  List<ChatMessage> messages = [];

  ChatState _state = PrepareTyping();
  ChatState get state => _state;

  String get response => _response;
  String _response = '';

  late int streamIndex;

  Future<void> send(String message) async {
    _response = '';
    final msg = ChatMessage(response: message, isMe: true);
    messages.add(msg);
    _addMessageUseCase.call(AddMessageParam(msg));
    notifyListeners();
    try {
      final param = AssistantRequest(prompt: message, stream: true);
      final stream = _chatUseCase.call(AssistantParam(param));
      messages.add(ChatMessage(response: _response, isMe: false));
      streamIndex = messages.length - 1;
      stream.listen(
        (event) {
          event.fold(
            (error) {
              _state = SendError(error.message, error.statusCode);
              notifyListeners();
            },
            (chunk) {
              _response += chunk.response;
              _state = Sent(message: ChatMessage(response: _response, isMe: false), response: chunk);
              messages[streamIndex] = ChatMessage(response: _response, isMe: false);
              notifyListeners();
            }
          );
        },
        onDone: () {
          final msg = ChatMessage(response: _response, isMe: false);
          _state = Sent(message: msg, response: AssistantResponse(response: _response));
          _addMessageUseCase.call(AddMessageParam(msg));
          streamIndex = -1;
          notifyListeners();
        }
      );
    } catch (e) {
      rethrow;
    }
  }
}

abstract class ChatState {
  const ChatState();
}

class PrepareTyping extends ChatState { }

class Sending extends ChatState { }

class Sent extends ChatState {
  final ChatMessage message;
  final AssistantResponse response;
  const Sent({required this.message, required this.response});
}

class SendError extends ChatState {
  final String? message;
  final int? code;
  SendError(this.message, this.code);
}