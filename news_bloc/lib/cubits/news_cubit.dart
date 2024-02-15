import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:news_bloc/models/top_business_news.dart';
import 'package:news_bloc/repository/news_repossitory.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitial());

  TopBusinessNews? news;

  void getNews() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    bool notConnect = (connectivityResult == ConnectivityResult.none);
    if (notConnect) {
      emit(NewsConnectionFailed());
    }

    try {
      emit(NewsLoading());
      news = await NewsRepository().getTopBusinessNews();
      emit(NewsSuccess(news!));
    } catch (e) {
      //if (news == null){
        if (notConnect) {
          emit(NewsConnectionFailed());
        }
        else {
          emit(NewsFailed());
        }
      //}
      // else {
      //   emit(NewsSuccess(news!));
      // }
    }
  }

}
