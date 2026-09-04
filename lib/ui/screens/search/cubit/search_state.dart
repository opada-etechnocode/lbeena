part of 'search_cubit.dart';

 class SearchState {}

class SearchInitial extends SearchState {}


class LoadingSearchItemState extends SearchState {

}

class SuccessSearchItemState extends SearchState {
  final SearchItemModel? searchItemModel;
  SuccessSearchItemState(this.searchItemModel);
}

class ErrorSearchItemState extends SearchState {
  final String error;
  ErrorSearchItemState(this.error);
}