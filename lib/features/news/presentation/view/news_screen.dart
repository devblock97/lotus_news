import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lotus_news/core/components/device_layout_builder.dart';
import 'package:lotus_news/core/components/error_view.dart';
import 'package:lotus_news/core/components/no_data_view.dart';
import 'package:lotus_news/features/news/data/model/news_model.dart';
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
                          Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(news: news[index])));
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
    brandIcon: 'https://download.logo.wine/logo/BBC_News/BBC_News-Logo.wine.png',
    description: description,
    images: [
      ImageSource(src: 'https://tse1.mm.bing.net/th?q=Cnn%2010%20March%2016%202024%20Date&w=1280&h=720&c=5&rs=1&p=0')
    ],
    summary: 'It was not so long ago that Chloe Kelly was considering taking a break from football and Hannah Hampton had been dropped from the England squad.',
    title: 'Lionesses heading home after retaining European title with historic win over Spain',
    content: content
  ),
  NewsModel(
    id: 0.01,
    link: 'link',
    source: 'CNN News',
    brandIcon: 'https://download.logo.wine/logo/BBC_News/BBC_News-Logo.wine.png',
    description: description,
    images: [
      ImageSource(src: 'https://tse1.mm.bing.net/th?q=Cnn%2010%20October%205%202025%20Schedule&w=1280&h=720&c=5&rs=1&p=0')
    ],
    summary: 'It was not so long ago that Chloe Kelly was considering taking a break from football and Hannah Hampton had been dropped from the England squad.',
    title: 'Lionesses heading home after retaining European title with historic win over Spain',
    content: content
  ),
  NewsModel(
    id: 0.02,
    link: 'link',
    source: 'The Times',
    brandIcon: 'https://download.logo.wine/logo/BBC_News/BBC_News-Logo.wine.png',
    description: description,
    images: [
      ImageSource(src: 'https://ichef.bbci.co.uk/ace/standard/1024/cpsprodpb/5b63/live/16005c50-6b30-11f0-89ea-4d6f9851f623.jpg')
    ],
    summary: 'It was not so long ago that Chloe Kelly was considering taking a break from football and Hannah Hampton had been dropped from the England squad.',
    title: 'Lionesses heading home after retaining European title with historic win over Spain',
    content: content
  ),
  NewsModel(
    id: 0.03,
    link: 'link',
    source: 'The Times',
    brandIcon: 'https://download.logo.wine/logo/BBC_News/BBC_News-Logo.wine.png',
    description: description,
    images: [
      ImageSource(src: 'https://ichef.bbci.co.uk/news/800/cpsprodpb/1261/live/4947d660-6c7a-11f0-8dbd-f3d32ebd3327.jpg.webp')
    ],
    summary: 'It was not so long ago that Chloe Kelly was considering taking a break from football and Hannah Hampton had been dropped from the England squad.',
    title: 'Lionesses heading home after retaining European title with historic win over Spain',
    content: content
  )
];

const String content = '''
At least 25 people have been killed across Ukraine in overnight and early morning Russian air strikes that hit a prison and a hospital, local officials say. They say the deadliest attack was on the Bilenke penitentiary in the southern Zaporizhzhia region, where 16 inmates were killed and more than 50 injured. A separate Russian strike on people queuing for humanitarian aid killed five in the north-eastern Kharkiv region. Three people were killed in the central Dnipropetrovsk region, including a pregnant woman. Another casualty was reported elsewhere in the region.
Later on Tuesday, Donald Trump confirmed a deadline of 8 August for Russia to agree a ceasefire, or else face sweeping sanctions. The US president had issued an ultimatum to Moscow on Monday during a visit to the UK, saying he would reduce the 50-day deadline previously issued to Russian President Vladimir Putin earlier this month. In response to the overnight strikes on Ukraine, Zelensky said Russia "must be forced to stop the killings and make peace" via "tough" sanctions. In a statement on Tuesday morning, Ukraine's justice ministry said four glide bombs hit the Bilenke penitentiary shortly before midnight, destroying the dining hall, administrative headquarters and quarantine area.
It said that more than 50 people were injured, and 44 of them had to be taken to hospital. The ministry had earlier reported 17 inmates were killed but later amended the death toll. Ukraine's human rights commissioner said attacking a prison was a gross violation of humanitarian law as people in detention did not lose their right to life and protection. Russian forces have frequently targeted the front-line region of Zaporizhzhia since the start of the full-scale invasion of Ukraine in 2022. It is one of four south-eastern regions in Ukraine that Russia claims to have annexed since 2022, although Moscow does not fully control any of them. In a separate Russian rocket attack on Tuesday morning, five people were killed in the village of Novoplatonivka, Kharkiv region, the local authorities said. The villagers had gathered near a local shop to get humanitarian aid, regional police chief Petro Tokar told Ukraine's Suspilne TV channel.
Ukraine's officials later released photos showing bodies lying near a destroyed shop. Another Russian rocket strike hit a hospital in Kamianske, Dnipropetrovsk region, killing three people. A 23-year-old pregnant woman named Diana was among the casualties there, President Zelensky said. In a statement, he accused Russia of killing Ukrainians when a ceasefire "could have long been in place". Earlier in July, Trump set a 50-day deadline for the Kremlin to reach a truce with Kyiv or risk economic penalties, but the warning has not halted Russia's barrage of strikes. The wave of attacks came as Russia said its troops were pushing deeper into Ukrainian territory. At the weekend, Moscow said its forces had seized the village of Maliivka, weeks after claiming control over their first village in the Dnipropetrovsk region. Ukraine has rejected Russia's claims.
Meanwhile, in Russia, officials said Ukraine had launched dozens of drones overnight in the southern Rostov region, killing one person in their car in the town of Salsk and setting fire to a goods train. Another person was reported killed in their car in the border region of Belgorod and his wife was wounded.
''';

// const String content = '''
// Đình Bắc ghi bàn cho đội tuyển Việt Nam ngay trong trận ra mắt (ở trận thắng 2-0 trước Philippines tại vòng loại World Cup 2026), rồi sau đó biến trận gặp Nhật Bản tại Asian Cup 2023 trở thành sân khấu riêng với 1 bàn thắng, cùng hàng loạt pha cầm bóng xử lý tự tin. Dù anh đối mặt với đội tuyển chỉ trước đó 1 năm vừa thắng Đức, Tây Ban Nha ở World Cup.
// Đình Bắc tự tin, có đôi chút "ngông", nhưng hào quang ập đến quá sớm khiến chân sút xứ Nghệ trải qua giai đoạn trầm lắng sau đó. Lùm xùm tại CLB Quảng Nam, quãng thời gian đầu khó khăn tại CLB Công an Hà Nội (CLB CAHN) từng cản đường tiến của một trong những ngôi sao trẻ triển vọng nhất. Đình Bắc cần một cú hích để bứt phá, và giải U.23 Đông Nam Á đã đến đúng lúc, khi trở thành bước đệm đưa chân sút 21 tuổi trở lại nơi anh thuộc về.
// ''';

const String description = '''
It was not so long ago that Chloe Kelly was considering taking a break from football and Hannah Hampton had been dropped from the England squad.
How things change. Now the pair have been heralded as England's Euro 2025 heroines after the Lionesses retained their European title.
Substitute Kelly assisted Alessia Russo's equaliser and scored the winning penalty, having feared for her place in England's Euros squad following a difficult start to the season with Manchester City.
Hampton was the focus of attention at the start of the tournament after she stepped up as England's first-choice keeper following Mary Earps' retirement, and made a string of crucial stops during the final before making two saves in the penalty shootout.''';