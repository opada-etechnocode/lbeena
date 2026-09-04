part of 'community_cubit.dart';
 class CommunityState {}

class CommunityInitial extends CommunityState {}

class LoadingGetAllCommunityPostState extends CommunityState {}
class ChangeLikeState extends CommunityState {
  Map<int, PostLikeInfo> postLikes = {};

  ChangeLikeState(this.postLikes);
}

class SuccessGetAllCommunityPostState extends CommunityState {
  final CommunityPostModel data;

  SuccessGetAllCommunityPostState(this.data);
}


/// get status Recorder
class LoadingStatusRecorderState extends CommunityState {

}
class SuccessStatusRecorderState extends CommunityState {
  final StatusRecorderModel statusRecorderModel;
  SuccessStatusRecorderState(this.statusRecorderModel);
}
class ErrorStatusRecorderState extends CommunityState {
  final String error;
  ErrorStatusRecorderState(this.error);
}

 class SuccessGetAllCommunityPostForLikeState extends CommunityState {
   List<CommunityModelDatum> communityPostModel = [];

  SuccessGetAllCommunityPostForLikeState(this.communityPostModel);
}

class ErrorGetAllCommunityPostState extends CommunityState {
  final String message;

  ErrorGetAllCommunityPostState(this.message);
}

class isVoicePlayPostState extends CommunityState {}
/// get loader post
class LoadingGetLoaderPostState extends CommunityState {}
class SuccessGetLoaderPostState extends CommunityState {
  final CommunityPostModel data;

  SuccessGetLoaderPostState(this.data);
}
class ErrorGetLoaderPostState extends CommunityState {
  final String message;

  ErrorGetLoaderPostState(this.message);
}



/// get loader post
class LoadingSendNotificationsPostState extends CommunityState {}
class SuccessSendNotificationsPostState extends CommunityState {
  final GeneralModel data;

  SuccessSendNotificationsPostState(this.data);
}
class ErrorSendNotificationsPostState extends CommunityState {
  final String error;

  ErrorSendNotificationsPostState(this.error);
}
/// get Comments By Id Posts
class LoadingGetCommentsByIdPostsState extends CommunityState {}
class SuccessGetCommentsByIdPostsState extends CommunityState {
  final CommentsByIdPostsModel data;

  SuccessGetCommentsByIdPostsState(this.data);
}

class ErrorGetCommentsByIdPostsState extends CommunityState {
  final String message;

  ErrorGetCommentsByIdPostsState(this.message);
}

/// like Post
class LoadingLikePostState extends CommunityState {}
class SuccessLikePostState extends CommunityState {
  final CommentsByIdPostsModel  data ;

  SuccessLikePostState(this.data);
}
class ErrorLikePostState extends CommunityState {
  final String message;

  ErrorLikePostState(this.message);
}
/// like Comment
class LoadingLikeCommentsState extends CommunityState {}
class SuccessLikeCommentsState extends CommunityState {
  final CommentsByIdPostsModel  data ;

  SuccessLikeCommentsState(this.data);
}
class ErrorLikeCommentsState extends CommunityState {
  final String message;

  ErrorLikeCommentsState(this.message);
}
/// create Comments
class LoadingCreateCommentsState extends CommunityState {}
class LoadingGetLoaderCommentsState extends CommunityState {}
class SuccessCreateCommentsState extends CommunityState {
  final CreateCommentModel  data ;

  SuccessCreateCommentsState(this.data);
}
class ErrorCreateCommentsState extends CommunityState {
  final String message;

  ErrorCreateCommentsState(this.message);
}
/// create Post
class LoadingCreatePostState extends CommunityState {}
class SuccessCreatePostState extends CommunityState {
  final CreatePostModel  data ;

  SuccessCreatePostState(this.data);
}
class ErrorCreatePostState extends CommunityState {
  final String message;

  ErrorCreatePostState(this.message);
}

/// add Comment
class LoadingAddCommentState extends CommunityState {}
class SuccessAddCommentState extends CommunityState {
  final CreateCommentModel  data ;

  SuccessAddCommentState(this.data);
}
class ErrorAddCommentState extends CommunityState {
  final String message;

  ErrorAddCommentState(this.message);
}

/// edit Post
class LoadingEditPostState extends CommunityState {}
class SuccessEditPostState extends CommunityState {
  final GeneralModel  data ;

  SuccessEditPostState(this.data);
}
class ErrorEditPostState extends CommunityState {
  final String message;

  ErrorEditPostState(this.message);
}

/// delete Post
class LoadingDeletePostState extends CommunityState {}
class SuccessDeletePostState extends CommunityState {
  final DeletePost  data ;
  final int  indexPost ;

  SuccessDeletePostState(this.data,this.indexPost);
}
class ErrorDeletePostState extends CommunityState {
  final String message;

  ErrorDeletePostState(this.message);
}


class SuccessAddGetCommentsByIdPostsState extends CommunityState {
  final String message;

  SuccessAddGetCommentsByIdPostsState(this.message);
}

/// delete Comment
class LoadingDeleteCommentState extends CommunityState {}
class SuccessDeleteCommentState extends CommunityState {
  final GeneralModel  data ;
  final int  indexComment ;

  SuccessDeleteCommentState(this.data, this.indexComment);
}
class ErrorDeleteCommentState extends CommunityState {
  final String message;

  ErrorDeleteCommentState(this.message);
}
/// edit Comment
class LoadingEditCommentState extends CommunityState {}
class SuccessEditCommentState extends CommunityState {
  final CreateCommentModel  data ;
  final int  indexComment ;

  SuccessEditCommentState(this.data,this.indexComment);
}
class ErrorEditCommentState extends CommunityState {
  final String message;

  ErrorEditCommentState(this.message);
}


/// get all hashtag
class LoadingGetAllHashtagPostState extends CommunityState {}
class SuccessGetAllHashtagPostState extends CommunityState {
  final AllHashtagModel data;

  SuccessGetAllHashtagPostState(this.data);
}
class ErrorGetAllHashtagPostState extends CommunityState {
  final String message;

  ErrorGetAllHashtagPostState(this.message);
}

/// get post by id
class LoadingGetPostByIdState extends CommunityState {}
class SuccessGetPostByIdState extends CommunityState {
  final PostModel data;

  SuccessGetPostByIdState(this.data);
}
class ErrorGetPostByIdState extends CommunityState {
  final String message;

  ErrorGetPostByIdState(this.message);
}