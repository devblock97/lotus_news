import 'package:equatable/equatable.dart';
import 'package:lotus_news/core/mapper/mapper.dart';
import 'package:lotus_news/features/news/domain/entities/news_entity.dart';

class NewsModel extends Equatable
    with EntityConvertible<NewsEntity, NewsModel> {
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
      thumbnail: json['url'],
    );
  }

  Map<String, dynamic> toJson() => {'id': id};

  @override
  NewsModel toEntity() {
    throw NewsEntity(id: id);
  }

  @override
  NewsEntity fromEntity(NewsModel model) {
    return NewsEntity(id: model.id);
  }

  @override
  List<Object?> get props => [
    id,
    body,
    summary,
    createdAt,
    score,
    title,
    thumbnail,
    shortDescription,
    avatar,
    brandName,
  ];
}

class ImageSource {
  final String src;
  const ImageSource({required this.src});

  factory ImageSource.fromJson(Map<String, dynamic> json) {
    return ImageSource(src: json['src'] ?? '');
  }
}
