import 'package:lotus_news/core/mapper/mapper.dart';
import 'package:lotus_news/features/news/domain/entities/news_entity.dart';

class NewsModel with EntityConvertible<NewsEntity, NewsModel> {
  final String id;
  final String body;
  final String? summary;
  final String createdAt;
  final int score;
  final String title;
  final String? thumbnail;
  final String? shortDescription;
  final String? avatar;
  final String? brandName;
  final String? content;

  const NewsModel({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.score,
    required this.title,
    this.thumbnail,
    this.avatar,
    this.brandName,
    this.shortDescription,
    this.summary,
    this.content
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      body: json['body'] ?? '',
      score: json['score'],
      createdAt: json['created_at'],
      shortDescription: json['short_description'],
      summary: json['summary'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
  };

  @override
  NewsModel toEntity() {
    throw NewsEntity(id: id, );
  }

  @override
  NewsEntity fromEntity(NewsModel model) {
    return NewsEntity(id: model.id);
  }

}

class ImageSource {
  final String src;
  const ImageSource({required this.src});

  factory ImageSource.fromJson(Map<String, dynamic> json) {
    return ImageSource(src: json['src'] ?? '');
  }
}