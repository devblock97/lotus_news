import 'package:tma_news/core/mapper/mapper.dart';
import 'package:tma_news/features/news/domain/entities/news_entity.dart';

class NewsModel with EntityConvertible<NewsEntity, NewsModel> {
  final double id;
  final String link;
  final String source;
  final String description;
  final String summary;
  final List<ImageSource> images;
  final String title;
  final String? thumbnail;
  final String? shortDescription;
  final String? brandIcon;
  final String? brandName;

  const NewsModel({
    required this.id,
    required this.link,
    required this.source,
    required this.description,
    required this.images,
    required this.summary,
    this.brandIcon,
    this.brandName,
    required this.title,
    this.thumbnail,
    this.shortDescription
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      link: json['link'],
      source: json['source'],
      title: json['title'],
      description: json['description'],
      summary: json['summary'],
      images: (json['images'] as List).map((i) => ImageSource.fromJson(i)).toList()
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