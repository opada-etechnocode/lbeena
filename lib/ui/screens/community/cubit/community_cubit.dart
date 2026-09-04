import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../data/models/GeneralResult.dart';
import '../../../../data/models/auth/otp/otp_model.dart';
import '../../../../data/models/community/comments__id_posts_model.dart';
import '../../../../data/models/community/community_post_model.dart';
import '../../../../data/models/community/create_comment_model.dart';
import '../../../../data/models/community/hashtag_model.dart';
import '../../../../data/models/community/post_model.dart';
import '../../../../data/models/home_page/status_recoder_model.dart';
import '../../../../data/sources/community/community_data_source.dart';
import '../../../../data/sources/home_page/home_page_data_source.dart';
import '../list_coummunity.dart';

part 'community_state.dart';

class CommunityCubit extends Cubit<CommunityState> {
  CommunityCubit() : super(CommunityInitial());

  static CommunityCubit get(context) => BlocProvider.of(context);

  /// get All Community Post
  Future<void> getAllCommunityPost({required int page,String? hashtag,bool isSearchHashtag =false}) async {
    CommunityDataSourceImpl getAllCommunityPostDataImpl =
        const CommunityDataSourceImpl();
    try {
      emit(LoadingGetAllCommunityPostState());

      var getAllNotifications = !isSearchHashtag ?
          await getAllCommunityPostDataImpl.getAllCommunityPost(page: page):await getAllCommunityPostDataImpl.searchAllCommunityPostHashtag(page: page, hashtag: hashtag!) ;
      if (getAllNotifications.data != null) {
        emit(SuccessGetAllCommunityPostState(getAllNotifications.data!));
      } else {
        emit(
            ErrorGetAllCommunityPostState(getAllNotifications.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorGetAllCommunityPostState is : $e in $stack");
      emit(ErrorGetAllCommunityPostState("Error is $e"));
    }
  }

  bool isVoicePlay = false;

  changeVoicePlay(value){
    isVoicePlay =value;
    emit(isVoicePlayPostState());
  }

  /// get All Community Post
  Future<void> getAllLoadingCommunityPost({required int page,String? hashtag,bool isSearchHashtag =false}) async {
    CommunityDataSourceImpl getAllCommunityPostDataImpl =
        const CommunityDataSourceImpl();
    try {
      emit(LoadingGetLoaderPostState());

      var getAllNotifications = !isSearchHashtag ?
      await getAllCommunityPostDataImpl.getAllCommunityPost(page: page):await getAllCommunityPostDataImpl.searchAllCommunityPostHashtag(page: page, hashtag: hashtag!) ;
      if (getAllNotifications.data != null) {
        communityPostModel!.addAll(getAllNotifications.data!.data!.data);
        emit(SuccessGetLoaderPostState(getAllNotifications.data!));
      } else {
        emit(ErrorGetLoaderPostState(getAllNotifications.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorGetAllCommunityPostState is : $e in $stack");
      emit(ErrorGetLoaderPostState("Error is $e"));
    }
  }


  /// get colors app
  Future<void> getStatusRecorder() async {
    HomePageDataSourceImpl homePageDataSourceImpl =
    const HomePageDataSourceImpl();
    try {
      emit(LoadingStatusRecorderState());

      var status = await homePageDataSourceImpl.getStatusRecorder();

      if (status.data != null) {
        DIManager.findDep<SharedPrefs>()
            .setIsAllowVoice(status.data!.is_allow_voice);
        DIManager.findDep<SharedPrefs>()
            .setTimeVoice(status.data!.allow_voice_time);
        DIManager.findDep<SharedPrefs>()
            .setUserIsBlocked(status.data!.is_blocked);
        DIManager.findDep<SharedPrefs>().setIsPermissionChatGroup(status.data!.is_permission_chat);
        emit(SuccessStatusRecorderState(status.data!));
      } else {
        emit(ErrorStatusRecorderState(status.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ColorsApp is : $e in $stack");
      emit(ErrorStatusRecorderState("Error is $e"));
    }
  }

  /// get All Community Post
  Future<void> sendNotification({required String userId}) async {
    CommunityDataSourceImpl getAllCommunityPostDataImpl =
    const CommunityDataSourceImpl();
    try {
      emit(LoadingSendNotificationsPostState());

      var getAllNotifications = await getAllCommunityPostDataImpl.sendNotificationAddToGroup(userID: userId) ;
      if (getAllNotifications.data!.status ==true) {
        emit(SuccessSendNotificationsPostState(getAllNotifications.data!));
      } else {
        emit(ErrorSendNotificationsPostState(getAllNotifications.data!.message.toString()));
      }
    } catch (e, stack) {
      print("Error In ErrorGetAllCommunityPostState is : $e in $stack");
      emit(ErrorSendNotificationsPostState("Error is $e"));
    }
  }
  List<CommunityModelDatum> communityPostModel = [];
  /// get All Community Post
  Future<void> searchPost({required int page,String? hashtagId,String? content,bool isNeedShimmer =true}) async {
    CommunityDataSourceImpl getAllCommunityPostDataImpl =
    const CommunityDataSourceImpl();
    try {
      if(isNeedShimmer){

        emit(LoadingGetAllCommunityPostState());

      }else {
        communityPostModel.clear();
      }
      var getAllNotifications = await getAllCommunityPostDataImpl.searchPostHashtag(page: page, hashtagId: hashtagId,content:content) ;
      if (getAllNotifications.data != null) {
        communityPostModel.addAll(getAllNotifications.data!.data!.data);
        emit(SuccessGetAllCommunityPostState(getAllNotifications.data!));
      } else {
        emit(
            ErrorGetAllCommunityPostState(getAllNotifications.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorGetAllCommunityPostState is : $e in $stack");
      emit(ErrorGetAllCommunityPostState("Error is $e"));
    }
  }


  //
  // /// Refresh All Community Pos
  // Future<void> refreshAllCommunityPost() async {
  //   CommunityDataSourceImpl getAllCommunityPostDataImpl =
  //       const CommunityDataSourceImpl();
  //   try {
  //     // emit(LoadingGetAllCommunityPostState());
  //
  //     var getAllNotifications =
  //         await getAllCommunityPostDataImpl.getAllCommunityPost(page: );
  //     if (getAllNotifications.data != null) {
  //       if(!isClosed){
  //         emit(SuccessGetAllCommunityPostState(getAllNotifications.data!));
  //       }
  //       // emit(SuccessGetAllCommunityPostState(getAllNotifications.data!));
  //     } else {
  //       if(!isClosed){
  //       emit(
  //           ErrorGetAllCommunityPostState(getAllNotifications.error!.message!));}
  //     }
  //   } catch (e, stack) {
  //     print("Error In ErrorGetAllCommunityPostState is : $e in $stack");
  //     if(!isClosed){
  //     emit(ErrorGetAllCommunityPostState("Error is $e"));}
  //   }
  // }

  /// get post By Id
  Future<void> getPostById({required int idPost}) async {
    CommunityDataSourceImpl getPostByIdDataImpl =
        const CommunityDataSourceImpl();
    try {
      emit(LoadingGetPostByIdState());

      var getPostById = await getPostByIdDataImpl.getPostDetails(idPost: idPost);
      if (getPostById.data != null) {
        emit(SuccessGetPostByIdState(getPostById.data!));
      } else {
        emit(ErrorGetPostByIdState(getPostById.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorGetPostByIdState is : $e in $stack");
      emit(ErrorGetPostByIdState("Error is $e"));
    }
  }
  /// edit Comments
  Future<void> editPost(
      {required int idPost,
      required int isHaveComment,
        required int? isHaveChat,
      required String content,
      required String type,
        required List<String>? hashtags,
      String? background,
      File? image,
      String? video}) async {
    CommunityDataSourceImpl editPostDataImpl = const CommunityDataSourceImpl();
    try {
      emit(LoadingEditPostState());

      var editPost = await editPostDataImpl.editPost(
          idPost: idPost,
          content: content,
          type: type,
          isHaveChat: isHaveChat,
          background: background,
          hashtags: hashtags,
          image: image,
          isHaveComment:isHaveComment ,
          video: video);
      if (editPost.data != null) {
        emit(SuccessEditPostState(editPost.data!));
      } else {
        emit(ErrorEditPostState(editPost.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorEditPostState is : $e in $stack");
      emit(ErrorEditPostState("Error is $e"));
    }
  }

  /// edit Comments
  Future<void> editComments(
      {required int idComments,
      required int indexComment,
      required String content,
      required String idPost}) async {
    CommunityDataSourceImpl editCommentsDataImpl =
        const CommunityDataSourceImpl();
    try {
      emit(LoadingEditCommentState());

      var editComments = await editCommentsDataImpl.editComments(
          idComments: idComments, content: content);
      if (editComments.data != null) {
        emit(SuccessEditCommentState(editComments.data!,indexComment));
        // var getCommentsByIdPosts =
        //     await editCommentsDataImpl.getCommentsByIdPosts(idPost: idPost);
        //
        // emit(SuccessGetCommentsByIdPostsState(getCommentsByIdPosts.data!));
      } else {
        emit(ErrorEditCommentState(editComments.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorEditCommentsState is : $e in $stack");
      emit(ErrorEditCommentState("Error is $e"));
    }
  }

  /// delete Comments
  Future<void> deleteComments(
      {required int idComments, required String idPost,required indexComment}) async {
    CommunityDataSourceImpl deleteCommentsDataImpl =
        const CommunityDataSourceImpl();
    try {  if(!isClosed) {
      emit(LoadingDeleteCommentState());
    }
      var deleteComments =
          await deleteCommentsDataImpl.deleteComments(idComments: idComments);
      if (deleteComments.data != null) {
        if(!isClosed){
          emit(SuccessDeleteCommentState(deleteComments.data!,indexComment));
        }
      } else {
        emit(ErrorDeleteCommentState(deleteComments.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorDeleteCommentsState is : $e in $stack");
      if(!isClosed){
      emit(ErrorDeleteCommentState("Error is $e"));}
    }
  }

  /// delete Post
  Future<void> deletePost({required int idPost,required int indexPost}) async {
    CommunityDataSourceImpl deletePostDataImpl =
        const CommunityDataSourceImpl();
    try {
      emit(LoadingDeletePostState());

      var deletePost = await deletePostDataImpl.deletePost(idPost: idPost);
      if (deletePost.data != null) {
        emit(SuccessDeletePostState(deletePost.data!,indexPost));
      } else {
        emit(ErrorDeletePostState(deletePost.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorDeletePostState is : $e in $stack");
      emit(ErrorDeletePostState("Error is $e"));
    }
  }

  /// get Comments By Id Posts
  Future<void> getCommentsByIdPosts({required String idPost, required int page, required bool isLoadMore}) async {
    CommunityDataSourceImpl getCommentsByIdPostsDataImpl =
        const CommunityDataSourceImpl();
    try {
      if(!isLoadMore) {
        emit(LoadingGetCommentsByIdPostsState());
      }else{
        emit(LoadingGetLoaderCommentsState());
      }
      var getCommentsByIdPosts = await getCommentsByIdPostsDataImpl
          .getCommentsByIdPosts(idPost: idPost,page: page);
      if (getCommentsByIdPosts.data != null) {
        emit(SuccessGetCommentsByIdPostsState(getCommentsByIdPosts.data!));
      } else {
        emit(ErrorGetCommentsByIdPostsState(
            getCommentsByIdPosts.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorGetCommentsByIdPostsState is : $e in $stack");
      emit(ErrorGetCommentsByIdPostsState("Error is $e"));
    }
  }

  // List<CommunityModelDatum> communityPostModel = [];

  /// like Post
  Future<void> likePost(
      {required int idPost,

      required bool isFromUserPage,
        String? hashtag,bool isSearchHashtag =false
      }) async {
    CommunityDataSourceImpl likePostDataImpl = const CommunityDataSourceImpl();
    try {
      emit(LoadingLikePostState());
      List<CommunityModelDatum> communityPostModel = [];
      var likePost = await likePostDataImpl.likePost(idPost: idPost);
      if (likePost.data != null) {
        emit(SuccessLikePostState(likePost.data!));

        ///
      } else {
        emit(ErrorLikePostState(likePost.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorLikePostState is : $e in $stack");
      emit(ErrorLikePostState("Error is $e"));
    }
  }

  Map<int, PostLikeInfo> postLikes = {};

  void handleLikeTap(int postId) {
    // Simulate API call success and update state
    emit(LoadingLikePostState());
    final currentPost = postLikes[postId];
    print("currentPost $currentPost");

    postLikes[postId] = PostLikeInfo(
      isLiked: !currentPost!.isLiked,
      likeCount: currentPost.isLiked
          ? currentPost.likeCount - 1
          : currentPost.likeCount + 1,
    );
    emit(ChangeLikeState(postLikes));
  }

  /// like Comments
  Future<void> likeComments(
      {required String idComment,
      required String idPost,
      required int page}) async {
    CommunityDataSourceImpl likeCommentsDataImpl =
        const CommunityDataSourceImpl();
    try {
      emit(LoadingLikeCommentsState());

      var likeComments =
          await likeCommentsDataImpl.likeComments(idComment: idComment);
      if (likeComments.data != null) {
        emit(SuccessLikeCommentsState(likeComments.data!));
        // var getCommentsByIdPosts =
        //     await likeCommentsDataImpl.getCommentsByIdPosts(idPost: idPost);
        //
        // emit(SuccessGetCommentsByIdPostsState(getCommentsByIdPosts.data!));

        var getAllNotifications =
            await likeCommentsDataImpl.getAllCommunityPost(page: page);
        emit(SuccessGetAllCommunityPostState(getAllNotifications.data!));
      } else {
        emit(ErrorLikeCommentsState(likeComments.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorLikeCommentsState is : $e in $stack");
      emit(ErrorLikeCommentsState("Error is $e"));
    }
  }

  /// add Comment
  Future<void> addComment(
      {required int idPost, required String content}) async {
    CommunityDataSourceImpl addCommentDataImpl =
        const CommunityDataSourceImpl();
    try {
      emit(LoadingAddCommentState());

      var addComment = await addCommentDataImpl.createComments(
          idPost: idPost, content: content);
      if (addComment.data != null) {
        emit(SuccessAddCommentState(addComment.data!));
      } else {
        emit(ErrorAddCommentState(addComment.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorAddCommentState is : $e in $stack");
      emit(ErrorAddCommentState("Error is $e"));
    }
  }


  /// get all Hashtag Post
  Future<void> getAllHashtagPost() async {
    CommunityDataSourceImpl getAllHashtagPostDataImpl =
        const CommunityDataSourceImpl();
    try {
      emit(LoadingGetAllHashtagPostState());

      var getAllHashtagPost =
          await getAllHashtagPostDataImpl.getAllHashtagPost();
      if (getAllHashtagPost.data != null) {
        if(!isClosed){
          emit(SuccessGetAllHashtagPostState(getAllHashtagPost.data!));
        }
      } else {
        emit(ErrorGetAllHashtagPostState(getAllHashtagPost.error!.message!));
      }
    } catch (e, stack) {
      print("Error In ErrorGetAllHashtagPostState is : $e in $stack");
      emit(ErrorGetAllHashtagPostState("Error is $e"));
    }
  }

  /// create post
  Future<void> createPost(
      {required String content,
      required String type,
      required int isHaveComment,
      required int isHaveChat,
      required String visibility,
        int? isHaveChatGroup,
      String? background,
      String? voice_time,
      List<String>? hashtags,
      File? image,
        File? voice,
      String? video}) async {
    CommunityDataSourceImpl createPostDataImpl =
        const CommunityDataSourceImpl();
    try {
      if(!isClosed) {
        emit(LoadingCreatePostState());
      }
      var createPost = await createPostDataImpl.createPost(
          content: content,
          type: type,visibility: visibility,
          background: background,
          image: image,
          video: video,isHaveChat: isHaveChat,
          isHaveChatGroup: isHaveChatGroup,
          voice_time: voice_time,
      voice:voice ,
      isHaveComment: isHaveComment,
      hashtags: hashtags);
      if (createPost.data != null) {
        if(!isClosed){
        emit(SuccessCreatePostState(createPost.data!));}
      } else {
        if(!isClosed){
          emit(ErrorCreatePostState(createPost.error!.message!));
        }
      }
    } catch (e, stack) {
      print("Error In ErrorCreatePostState is : $e in $stack");
      if(!isClosed){
      emit(ErrorCreatePostState("Error is $e"));}
    }
  }
}
