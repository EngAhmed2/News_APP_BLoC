import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:news/models/top_business_news.dart';
import 'package:news/repository/news_repository.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitial());
  void getNews() async {
    final news = await NewsRepository().getTopBusinessNews();
    try {
      emit(NewsLoading());

      emit(NewsSuccess(news: news));
    } catch (e) {
      if (news == null)
      emit(NewsFailed());
    }
  }
}
