part of 'news_cubit.dart';

@immutable
abstract class NewsState {}

class NewsInitial extends NewsState {}
class NewsLoading extends NewsState {}
class NewsSuccess extends NewsState {
  final TopBusinessNews news;
  NewsSuccess(this.news);
}
class NewsFailed extends NewsState {}
class NewsConnectionFailed extends NewsState {}
