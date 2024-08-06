import '../model/new_headline_model.dart';
import '../model/news_categories_model.dart';
import '../respository/news_repository.dart';

class NewsViewModel {
  final _repo = NewsRepository();
  Future<NewsHeadLineModel> newsHeadlineApi(String channelName) async {
    final response = await _repo.newsHeadlineApi(channelName);
    return response;
  }

  Future<NewsCategoriesModel> categoriesRepositoryApi(String categories) async {
    final response = await _repo.categoriesRepositoryApi(categories);
    return response;
  }
}
