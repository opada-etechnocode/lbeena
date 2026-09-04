import 'package:syrians_in_uae/data/models/news/news_model.dart';
import 'package:syrians_in_uae/data/models/news/news_related_model.dart';
import 'package:syrians_in_uae/data/sources/news/news_data_source.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'news_bloc_state.dart';

class NewsBlocCubit extends Cubit<NewsBlocState> {
  NewsBlocCubit() : super(NewsBlocInitial());
  static NewsBlocCubit get(context) => BlocProvider.of(context);


/// get Related News
  Future<void> getRelatedNews({
    required int idNew
}) async {
    NewsDataSourceImpl getAllNewsDataImpl =
    const NewsDataSourceImpl();
    try {
      emit(LoadingRelatedNewsState());

      var getAllNotifications =
      await getAllNewsDataImpl.getRelatedNewsModel(idNew: idNew);
      if (getAllNotifications.data != null) {
        emit(SuccessRelatedNewsState(getAllNotifications.data!));
      } else {
        emit(ErrorRelatedNewsState(getAllNotifications.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorGetAllNewsState is : $e in $stack");
      emit(ErrorRelatedNewsState("Error is $e"));
    }
  }


  /// get All News
  Future<void> getAllNews({required page,bool isLoading =false}) async {
    NewsDataSourceImpl getAllNewsDataImpl =
    const NewsDataSourceImpl();
    try {
      if(!isLoading) {
        emit(LoadingGetAllNewsState());
      }else {
        emit(LoadingGetLoaderNewsState());

      }
      var getAllNotifications =
      await getAllNewsDataImpl.getAllNews(page:page);
      if (getAllNotifications.data != null) {
        emit(SuccessGetAllNewsState(getAllNotifications.data!));
      } else {
        emit(ErrorGetAllNewsState(getAllNotifications.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorGetAllNewsState is : $e in $stack");
      emit(ErrorGetAllNewsState("Error is $e"));
    }
  }





  /// get Search News
  Future<void> getSearchNews({
    required String title, required int page, required bool isLoading,
}) async {
    NewsDataSourceImpl getAllNewsDataImpl =
    const NewsDataSourceImpl();
    try {
      if(!isLoading) {
        emit(LoadingSearchNewsState());
      }else {
        emit(LoadingGetLoaderNewsState());

      }
      var getAllNotifications =
      await getAllNewsDataImpl.getSearchNews(title: title,page: page);
      if (getAllNotifications.data != null) {
        emit(SuccessSearchNewsState(getAllNotifications.data!));
      } else {
        emit(ErrorSearchNewsState(getAllNotifications.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorGetAllNewsState is : $e in $stack");
      emit(ErrorSearchNewsState("Error is $e"));
    }
  }




  /// get All News
  Future<void> getItemNews({
    required int idNew
}) async {
    NewsDataSourceImpl getAllNewsDataImpl =
    const NewsDataSourceImpl();
    try {
      emit(LoadingGetAllNewsState());

      var getAllNotifications =
      await getAllNewsDataImpl.getItemNews(idNew: idNew);
      if (getAllNotifications.data != null) {
        emit(SuccessGetNewState(getAllNotifications.data!.news[0]));
      } else {
        emit(ErrorGetAllNewsState(getAllNotifications.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorGetAllNewsState is : $e in $stack");
      emit(ErrorGetAllNewsState("Error is $e"));
    }
  }

}
