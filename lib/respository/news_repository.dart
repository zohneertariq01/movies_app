import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/model/news_categories_model.dart';

import '../model/new_headline_model.dart';

class NewsRepository {
  Future<NewsHeadLineModel> newsHeadlineApi(String channelName) async {
    final String url =
        "https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=a6c789d6ed954e84bb42d5b0fc5bbe48";
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body.toString());
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsHeadLineModel.fromJson(body);
    }
    throw Exception("Error");
  }

  Future<NewsCategoriesModel> categoriesRepositoryApi(String categories) async {
    String url =
        "https://newsapi.org/v2/everything?q=${categories}&apiKey=a6c789d6ed954e84bb42d5b0fc5bbe48";
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body.toString());
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body.toString());
      return NewsCategoriesModel.fromJson(body);
    }
    throw Exception("Error");
  }
}
