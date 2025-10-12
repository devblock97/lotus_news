import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:lotus_news/features/assistant/presentation/view_model/chat_view_model.dart';

import '../../data/model/chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    context.read<ChatViewModel>().send(text);

    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: theme.appBarTheme.backgroundColor,
      ),
      body: Consumer<ChatViewModel>(
        builder: (_, state, child) {
          return Column(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<ChatMessage>(
                    'chatBox',
                  ).listenable(),
                  builder: (context, Box<ChatMessage> box, _) {
                    final messages = box.values.toList();
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return Align(
                          alignment: message.isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.85,
                            ),
                            decoration: BoxDecoration(
                              color: message.isMe
                                  ? Colors.green
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              message.response,
                              style: TextStyle(
                                color: message.isMe
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: _sendMessage,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _sendMessage(_controller.text),
                      icon: Icon(Icons.send, color: theme.primaryColor),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
