import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lotus_news/core/constants/app_constants.dart';
import 'package:lotus_news/features/news/data/model/news_model.dart';
import 'package:lotus_news/features/news/presentation/view/detail_screen.dart';
import 'package:lotus_news/features/news/presentation/widgets/news_card.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PostStream extends StatefulWidget {
  const PostStream({super.key});

  @override
  State<PostStream> createState() => _PostStreamState();
}

class _PostStreamState extends State<PostStream> {

  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    debugPrint('on init state');
    _channel = WebSocketChannel.connect(Uri.parse(AppConstants.wsUrl(false)));
  }

  @override
  void dispose() {
    debugPrint('on disposed');
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _channel.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          debugPrint('socket connecting...');
          return const SizedBox.shrink();
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}. Check server/URL'),);
        }

        if (snapshot.hasData) {
          try {
            // snapshot.data is the raw string from the websocket
            final String jsonString = snapshot.data.toString();
            final Map<String, dynamic> jsonData = jsonDecode(jsonString);
            final NewsModel news = NewsModel.fromJson(jsonData);

            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(news: news)));
              },
              child: NewsCard(news: news)
            );
          } catch (e) {
            debugPrint('Failed to decode JSON or map to Post: $e');
          }
        }

        return const SizedBox.shrink();
      }
    );
  }
}
