import 'package:dio/dio.dart';
import 'package:news/models/top_business_news.dart';

class NewsRepository {
  final _dio = Dio();
  final path =
      'https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=02252582c8a6486893f9c6f84a604377';

  Future<TopBusinessNews> getTopBusinessNews() async {
    final response = await _dio.get(path);
    final newsData = TopBusinessNews.fromJson(response.data);
    return newsData;
  }
}