import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tma_news/core/components/device_layout_builder.dart';
import 'package:tma_news/core/components/error_view.dart';
import 'package:tma_news/core/components/no_data_view.dart';
import 'package:tma_news/features/news/data/model/news_model.dart';
import 'package:tma_news/features/news/presentation/view_model/news_view_model.dart';
import 'package:tma_news/features/news/presentation/widgets/card_skeleton.dart';
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
              final news = newsData;
              if (news.isEmpty) return Center(child: NoDataView(message: 'Không có dữ liệu về tin tức',));
              return DeviceLayoutBuilder(
                mobileView: (_) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: news.length,
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        onTap: () {

                        },
                        child: NewsCard(index: index, news: news[index])
                      );
                    },
                  );
                },
                tabletView: (_) {
                  return GridView.builder(
                    itemCount: news.length,
                    itemBuilder: (_, index) {
                      return NewsCard(index: index, news: news[index], isPhone: false,);
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

const List<NewsModel> newsData = [
  NewsModel(
    id: 0.00,
    link: 'link',
    source: 'BBC News',
    description: description,
    images: [
      ImageSource(src: 'https://tse1.mm.bing.net/th?q=Cnn%2010%20March%2016%202024%20Date&w=1280&h=720&c=5&rs=1&p=0')
    ],
      summary: 'It was not so long ago that Chloe Kelly was considering taking a break from football and Hannah Hampton had been dropped from the England squad.',
      title: 'Lionesses heading home after retaining European title with historic win over Spain'
  ),
  NewsModel(
      id: 0.01,
      link: 'link',
      source: 'CCN News',
      description: description,
      images: [
        ImageSource(src: 'https://tse1.mm.bing.net/th?q=Cnn%2010%20October%205%202025%20Schedule&w=1280&h=720&c=5&rs=1&p=0')
      ],
      summary: 'It was not so long ago that Chloe Kelly was considering taking a break from football and Hannah Hampton had been dropped from the England squad.',
      title: 'Lionesses heading home after retaining European title with historic win over Spain'
  ),
  NewsModel(
      id: 0.02,
      link: 'link',
      source: 'The Times',
      description: description,
      images: [
        ImageSource(src: 'https://ichef.bbci.co.uk/ace/standard/1024/cpsprodpb/5b63/live/16005c50-6b30-11f0-89ea-4d6f9851f623.jpg')
      ],
      summary: 'It was not so long ago that Chloe Kelly was considering taking a break from football and Hannah Hampton had been dropped from the England squad.',
      title: 'Lionesses heading home after retaining European title with historic win over Spain'
  )
];

const String description = '''
It was not so long ago that Chloe Kelly was considering taking a break from football and Hannah Hampton had been dropped from the England squad.
How things change. Now the pair have been heralded as England's Euro 2025 heroines after the Lionesses retained their European title.
Substitute Kelly assisted Alessia Russo's equaliser and scored the winning penalty, having feared for her place in England's Euros squad following a difficult start to the season with Manchester City.
Hampton was the focus of attention at the start of the tournament after she stepped up as England's first-choice keeper following Mary Earps' retirement, and made a string of crucial stops during the final before making two saves in the penalty shootout.''';