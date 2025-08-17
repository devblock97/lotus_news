import 'package:hive/hive.dart';
import 'package:tma_news/features/assistant/data/model/chat_message.dart';

abstract class ChatLocalDataSource {
  Future<void> addMessage(ChatMessage message) => throw UnimplementedError('Stub');
  Future<List<ChatMessage>> retrieve() => throw UnimplementedError('Stub');
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {

  static final String chatBox = 'chatBox';

  ChatLocalDataSourceImpl();

  @override
  Future<List<ChatMessage>> retrieve() async {
    try {
      final box = Hive.box<ChatMessage>(chatBox);
      return box.values.toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addMessage(ChatMessage message) async {
    try {
      final box = Hive.box<ChatMessage>(chatBox);
      box.add(message);
    } catch (e) {
      rethrow;
    }
  }
}