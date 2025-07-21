import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tma_news/features/news/data/model/news_model.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.news, this.isMobile = true});

  final NewsModel news;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade400, blurRadius: 6, spreadRadius: 2),
        ]
      ),
      child: Column(
        children: [
          _buildThumbnail(context),
          const SizedBox(height: 5,),
          _buildTitle(theme),
          const SizedBox(height: 5,),
          _buildBrand(theme),
          const SizedBox(height: 5,),
          _buildShortDescription(),
          const SizedBox(height: 5,),
          _buildAction(theme)
        ],
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(15),
      ),
      child: Image.network(
        news.thumbnail ?? '',
        height: MediaQuery.of(context).size.height * (isMobile ? 0.25 : 0.45),
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
        // loadingBuilder: (_, skeleton, ice) {
        //   debugPrint('loading image progress: ${ice?.cumulativeBytesLoaded}');
        //   return SizedBox(
        //     height: 180,
        //     width: double.maxFinite,
        //     child: Shimmer.fromColors(
        //       baseColor: Colors.white,
        //       highlightColor: Colors.grey.shade300,
        //       child: ColoredBox(color: Colors.grey)
        //     ),
        //   );
        // },
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              news.title ?? '',
              style: theme.textTheme.titleMedium,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrand(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          CircleAvatar(
            maxRadius: 10,
            backgroundColor: Colors.white,
            child: Image.network(news.brandIcon ?? ''),
          ),
          const SizedBox(width: 5),
          Text(
            news.brandName ?? '',
            style: theme.textTheme.labelSmall,
          ),
          const SizedBox(width: 5),
          Icon(
            Icons.check_circle_outline,
            color: Colors.blueAccent,
            size: 14,
          ),
        ],
      ),
    );
  }

  Widget _buildShortDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        news.shortDescription ?? '',
        maxLines: 3,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 13),
      ),
    );
  }

  Widget _buildAction(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite, color: Colors.red,)
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.comment_rounded, color: Colors.blueAccent)),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share_rounded)),
          const Spacer(),
          Text('101 Comments, 48.3k Views', style: theme.textTheme.labelSmall!.copyWith(fontSize: 12),)
        ],
      ),
    );
  }
}

const List<NewsModel> newsList = [
  NewsModel(
    id: 1,
    account: '',
    brandName: 'CCN News',
    thumbnail: 'https://tse1.mm.bing.net/th?q=Cnn%2010%20March%2016%202024%20Date&w=1280&h=720&c=5&rs=1&p=0',
    title: 'BBC Studios partners with Delta Air Lines to bring live 24-7',
    shortDescription: '''CNN — Moscow barreled hundreds of drones toward four key regions in Ukraine overnight, just as lawmakers in Kyiv scrambled to approve additional defense spending against the backdrop of intensified Russian attacks over the past few days.
      The Kremlin unleashed 400 long-range drones and one missile late Tuesday, according to Ukraine’s Air Force – in what marked largest onslaught so far this week. Kyiv’s forces intercepted or disabled at least 345 of those drones.
      ''',
    brandIcon: 'https://th.bing.com/th/id/R.e6c04b140dd6f17d066ec119f396c1c4?rik=QL%2fdAqVvkYTNlw&riu=http%3a%2f%2fwww.freepnglogos.com%2fuploads%2fcnn-logo-circle-icon-png-12.png&ehk=zqkjaAoOwfj7sk1LFisRn7UQ%2fzZzTyu4LWnKQw2GqYM%3d&risl=&pid=ImgRaw&r=0'
  ),
  NewsModel(
    id: 2,
    account: 'account',
    brandName: 'CNN News',
    title: 'BBC Studios partners with Delta Air Lines to bring live 24-7',
    thumbnail: 'https://tse1.mm.bing.net/th?q=Cnn%2010%20October%205%202025%20Schedule&w=1280&h=720&c=5&rs=1&p=0',
    shortDescription: '''CNN — Moscow barreled hundreds of drones toward four key regions in Ukraine overnight, just as lawmakers in Kyiv scrambled to approve additional defense spending against the backdrop of intensified Russian attacks over the past few days.
      The Kremlin unleashed 400 long-range drones and one missile late Tuesday, according to Ukraine’s Air Force – in what marked largest onslaught so far this week. Kyiv’s forces intercepted or disabled at least 345 of those drones.
      ''',
    brandIcon: 'https://th.bing.com/th/id/R.e6c04b140dd6f17d066ec119f396c1c4?rik=QL%2fdAqVvkYTNlw&riu=http%3a%2f%2fwww.freepnglogos.com%2fuploads%2fcnn-logo-circle-icon-png-12.png&ehk=zqkjaAoOwfj7sk1LFisRn7UQ%2fzZzTyu4LWnKQw2GqYM%3d&risl=&pid=ImgRaw&r=0'
  ),
  NewsModel(
    id: 3,
    account: 'account',
    title: 'It\'s just a weird, weird bird\': Why we got the dodo so absurdly wrong',
    thumbnail: 'https://nld.mediacdn.vn/thumb_w/698/291774122806476800/2025/7/14/z6802939858806bab0c7426ea7bc8f1045cc41d79fe11a-1752478527220933270543.jpg',
    shortDescription: ''''The extinct flightless pigeon has captured imaginations for over 400 years. Experts and artists are now revealing how much we have distorted what the dodo was really like – nimble and slender, with a formidable beak.
    ''',
    brandIcon: 'https://download.logo.wine/logo/BBC_News/BBC_News-Logo.wine.png',
    brandName: 'BBC News'
  ),
  NewsModel(
    id: 4,
    account: 'account',
    title: 'Hủy 48 chuyến bay trong 2 ngày do bão số 3, gần 7.700 khách bị ảnh hưởng',
    thumbnail: 'https://images2.thanhnien.vn/thumb_w/640/528068263637045248/2025/7/21/image-17530896010768764952.jpg',
    shortDescription: ''''Do ảnh hưởng của cơn bão Wipha (bão số 3) tại khu vực Hồng Kông (Trung Quốc), các hãng hàng không Việt Nam đã phải điều chỉnh kế hoạch khai thác hàng loạt chuyến bay trong 2 ngày 21 và 22.7.''',
    brandIcon: 'https://amthanhxehoi.com/wp-content/uploads/2020/04/logo-baothanhnien.png',
    brandName: 'Thanh Niên'
  ),
];
