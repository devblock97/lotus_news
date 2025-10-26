import 'package:flutter/material.dart';
import 'package:lotus_news/injector.dart';
import 'package:provider/provider.dart';
import 'package:lotus_news/core/components/device_layout_builder.dart';
import 'package:lotus_news/core/components/error_view.dart';
import 'package:lotus_news/core/components/no_data_view.dart';
import 'package:lotus_news/features/news/presentation/view/detail_screen.dart';
import 'package:lotus_news/features/news/presentation/view_model/news_view_model.dart';
import 'package:lotus_news/features/news/presentation/widgets/card_skeleton.dart';
import 'package:lotus_news/features/news/presentation/widgets/news_card.dart';
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
      create: (_) => NewsViewModel(injector(), injector())..getNews(),
      child: Consumer<NewsViewModel>(
        builder: (_, state, _) {
          switch (state.state) {
            case NewsSuccess data:
              final news = data.data;
              if (news.isEmpty) {
                return Center(
                  child: NoDataView(message: 'Không có dữ liệu về tin tức'),
                );
              }
              return DeviceLayoutBuilder(
                mobileView: (_) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: news.length,
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(news: news[index]),
                            ),
                          );
                        },
                        child: NewsCard(news: news[index]),
                      );
                    },
                  );
                },
                tabletView: (_) {
                  return GridView.builder(
                    itemCount: news.length,
                    itemBuilder: (_, index) {
                      return NewsCard(news: news[index], isPhone: false);
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      childAspectRatio: 1.1,
                    ),
                  );
                },
              );
            case NewsError message:
              return Center(child: ErrorView(message: message.message));
            case NewsLoading _:
              return NewsCardSkeleton();
            default:
              return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
