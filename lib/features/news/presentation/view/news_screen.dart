import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tma_news/core/components/dynamic_device_layout_builder.dart';
import 'package:tma_news/features/news/presentation/view_model/news_view_model.dart';
import 'package:tma_news/features/news/presentation/widgets/news_card.dart';
import '../view_model/news_state.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewsViewModel()..getNews(),
      child: Consumer<NewsViewModel>(
        builder: (_, state, _) {
          switch (state.state) {
            case NewsSuccess data:
              final news = data.data;
              if (news.isEmpty) return Text('Data is empty');
              return DynamicDeviceLayoutBuilder(
                mobileView: (_) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: news.length,
                    itemBuilder: (_, index) {
                      return NewsCard(news: newsList[index % 4]);
                    },
                  );
                },
                tabletView: (_) {
                  return GridView.builder(
                    itemCount: news.length,
                    itemBuilder: (_, index) {
                      return NewsCard(news: newsList[index % 4], isMobile: false,);
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      childAspectRatio: 1.1
                    ),
                  );
                }
              );
            case NewsError message:
              return Center(child: Text(message.message ?? ''));
            case NewsLoading _:
              return Center(child: CircularProgressIndicator());
            default:
              return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
