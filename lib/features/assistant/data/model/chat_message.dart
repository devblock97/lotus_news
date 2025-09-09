import 'package:hive/hive.dart';
import 'package:lotus_news/features/assistant/data/model/assistant_response.dart';
part 'chat_message.g.dart';

@HiveType(typeId: 0)
class ChatMessage extends HiveObject {
  @HiveField(0)
  String response;
  
  @HiveField(1)
  bool isMe;

  ChatMessage({required this.response, required this.isMe});
}
