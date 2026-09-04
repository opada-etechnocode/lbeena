part of 'news_bloc_cubit.dart';
class NewsBlocState {}

 class NewsBlocInitial extends NewsBlocState {}

 class LoadingSearchNewsState extends NewsBlocState {}
class SuccessSearchNewsState extends NewsBlocState {
  final NewsModel newsModel;

  SuccessSearchNewsState(this.newsModel);
}

class ErrorSearchNewsState extends NewsBlocState {
  final String error;

  ErrorSearchNewsState(this.error);
}
class LoadingGetLoaderNewsState extends NewsBlocState {}
/// Get All News Status
class LoadingGetAllNewsState extends NewsBlocState {}
class SuccessGetAllNewsState extends NewsBlocState {
  final NewsModel newsModel;

  SuccessGetAllNewsState(this.newsModel);
}


class SuccessGetNewState extends NewsBlocState {
  final NewsList data;

  SuccessGetNewState(this.data);
}

class ErrorGetAllNewsState extends NewsBlocState {
  final String error;

  ErrorGetAllNewsState(this.error);
}

class LoadingRelatedNewsState extends NewsBlocState {}

class SuccessRelatedNewsState extends NewsBlocState {
  final RelatedNewsModel newsModel;

  SuccessRelatedNewsState(this.newsModel);
}

class ErrorRelatedNewsState extends NewsBlocState {
  final String error;

  ErrorRelatedNewsState(this.error);
}
