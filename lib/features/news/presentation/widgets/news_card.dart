import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lotus_news/features/news/data/model/news_model.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.news, this.isPhone = true});

  final NewsModel news;
  final bool isPhone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 4,
            spreadRadius: 1.5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildThumbnail(context),
          const SizedBox(height: 5),
          _buildTitle(theme),
          const SizedBox(height: 5),
          // _buildBrand(theme),
          const SizedBox(height: 5),
          // _buildShortDescription(),
          const SizedBox(height: 5),
          // _buildAction(theme),
        ],
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: CachedNetworkImage(
        imageUrl:
            news.thumbnail ??
            'https://tse1.mm.bing.net/th?q=Cnn%2010%20March%2016%202024%20Date&w=1280&h=720&c=5&rs=1&p=0',
        height: MediaQuery.of(context).size.height * (isPhone ? 0.25 : 0.45),
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Expanded(
        child: Text(
          news.title,
          style: theme.textTheme.titleMedium,
          maxLines: 1,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
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
            child: Image.network(
              news.avatar ??
                  'https://download.logo.wine/logo/BBC_News/BBC_News-Logo.wine.png',
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              news.body,
              style: theme.textTheme.labelSmall,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 5),
          Icon(Icons.check_circle_outline, color: Colors.blueAccent, size: 14),
        ],
      ),
    );
  }

  Widget _buildShortDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        news.shortDescription ?? '',
        maxLines: isPhone ? 3 : 4,
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
            icon: Icon(Icons.favorite_outline, color: theme.iconTheme.color),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.comment_outlined, color: theme.iconTheme.color),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share_rounded, color: theme.iconTheme.color),
          ),
          const Spacer(),
          Text(
            '101 Comments, 48.3k Views',
            style: theme.textTheme.labelSmall!.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
