import 'package:tma_news/core/mapper/mapper.dart';
import 'package:tma_news/features/news/domain/entities/news_entity.dart';

class NewsModel with EntityConvertible<NewsEntity, NewsModel> {

  final int id;
  final String account;
  final String? title;
  final String? thumbnail;
  final String? shortDescription;
  final String? brandIcon;
  final String? brandName;

  const NewsModel({
    required this.id,
    required this.account,
    this.brandIcon,
    this.brandName,
    this.title,
    this.thumbnail,
    this.shortDescription
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      account: json['account'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'account': account
  };

  @override
  NewsModel toEntity() {
    throw NewsEntity(id: id, account: account);
  }

  @override
  NewsEntity fromEntity(NewsModel model) {
    return NewsEntity(id: model.id, account: model.account);
  }

}