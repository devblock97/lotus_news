import 'package:lotus_news/core/constants/app_constants.dart' show AppConstants;
import 'package:lotus_news/core/network/client.dart';
import 'package:lotus_news/features/news/data/model/news_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<NewsModel>> search(String keyword) =>
      throw UnimplementedError('Stub');
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Client client;

  SearchRemoteDataSourceImpl(this.client);

  @override
  Future<List<NewsModel>> search(String keyword) async {
    try {
      final response = await client.get(AppConstants.search(keyword));
      if (response.statusCode == 200) {
        final List<NewsModel> result = (response.data as List)
            .map((n) => NewsModel.fromJson(n))
            .toList();
        return result;
      } else {
        return [];
      }
    } catch (_) {
      rethrow;
    }
  }
}
