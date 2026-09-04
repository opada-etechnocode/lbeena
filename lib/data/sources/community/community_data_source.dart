import 'dart:io';

import 'package:syrians_in_uae/data/models/GeneralResult.dart';
import 'package:syrians_in_uae/data/models/auth/otp/otp_model.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../../../core/data_source/base_remote_data_source.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/net/http_method.dart';
import '../../../core/results/result.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../models/community/comments__id_posts_model.dart';
import '../../models/community/community_post_model.dart';
import '../../models/community/community_user_model.dart';
import '../../models/community/create_comment_model.dart';
import '../../models/community/hashtag_model.dart';
import '../../models/community/post_model.dart';
import '../../../core/utils/endpoints.dart';

abstract class CommunityDataSource {
  const CommunityDataSource();


  Future<Result<CommunityPostModel>> getAllCommunityPost({required int page});
  Future<Result<CommunityPostModel>> searchAllCommunityPostHashtag({required int page,required String hashtag});
  Future<Result<AllHashtagModel>> getAllHashtagPost();
  Future<Result<PostModel>> getPostDetails({required int idPost});
  Future<Result<CommunityPostUserModel>> getUserOrCompanyCommunityPost();
  Future<Result<GeneralModel>> sendNotificationAddToGroup({
    required String userID,
  });
  Future<Result<CommentsByIdPostsModel>> getCommentsByIdPosts({
    required String idPost,required int page,
  });

  Future<Result<CommentsByIdPostsModel>> likePost({
    required int idPost,
  });

  Future<Result<CommentsByIdPostsModel>> likeComments({
    required String idComment,
  });

  Future<Result<CreateCommentModel>> createComments({
    required String content,
    required int idPost,
  });


  Future<Result<GeneralModel>> editPost({
    required int idPost,
    required String content,
    String? background,
    String? video,
    required List<String>? hashtags,
    File? image,
    required String? type,
    required int? isHaveComment,
    required int? isHaveChat,
  });

  Future<Result<CreateCommentModel>> editComments({
    required int idComments,
    required String content,
  });


  Future<Result<DeletePost>> deletePost({
    required int idPost,
  });

  Future<Result<GeneralModel>> deleteComments({
    required int idComments,
  });
  Future<Result<CommunityPostModel>> searchPostHashtag({required int page, String? hashtagId, String? content});
  Future<Result<CreatePostModel>> createPost({
    required String content,
    required String visibility,
    String? background,
    String? video,

    List<String>? hashtags,
    required int isHaveComment,
    required int isHaveChat,
    File? image,
    required String type,
  });
}

class CommunityDataSourceImpl implements CommunityDataSource {
  const CommunityDataSourceImpl();

  @override
  Future<Result<PostModel>> getPostDetails({required int idPost}) async {
    return await RemoteDataSource.request<PostModel>(
      converter: (model) => PostModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {
        "post_id": idPost,
      },
      url: "${AppEndpoints.baseUrl}mobile/posts/posts_get_by_id",
    );
  }
  @override
  Future<Result<AllHashtagModel>> getAllHashtagPost() async {
    return await RemoteDataSource.request<AllHashtagModel>(
      converter: (model) => AllHashtagModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}mobile/posts/hash",
    );
  }
  String getHashtag({List<String>? hashtag}) {
    String hash = '';
    for (int i = 0; i < hashtag!.length; i++) {
      if(hash ==''){
        hash = hashtag[i];
      }else{
        hash = hash + ',' + hashtag[i];
      }
    }
    return hash;
  }
  @override
  Future<Result<CreatePostModel>> createPost({
    required String content,
    String? background,
    String? video,
    required String? visibility,
    String? voice_time,
    List<String>? hashtags,
    required int isHaveComment,
    required int isHaveChat,
     int? isHaveChatGroup,
    File? image,
    File? voice,
    required String? type,
  }) async {
    FormData formData;
    var imagePost;
    var voicePost;
    if (image != null) {
      imagePost = type !='B'?'': await MultipartFile.fromFile(
        image.path ?? '',
        filename: basename(image.path ?? ''),
      );
    }
    if (voice != null) {
      voicePost = type !='D'?'': await MultipartFile.fromFile(
        voice.path ?? '',
        filename: basename(voice.path ?? ''),
      );
    }

    print('visibility : $visibility');
   Map<String,dynamic> data = type == "A"
       ? {
     "content": content,
     "background": background,
     "visibility": visibility,
     "hashtags": getHashtag(hashtag: hashtags),
     "is_have_comment": isHaveComment,
     "is_have_chat": isHaveChat,
     "is_content_group": isHaveChatGroup,
   }
       : type == "B"
       ? {
     "content": content,
     "image": imagePost,
     "visibility": visibility,
     "hashtags": getHashtag(hashtag: hashtags),
     "is_have_comment": isHaveComment,"is_have_chat": isHaveChat,"is_content_group": isHaveChatGroup,
   }
       : type == "D"?{
     "content": content,
     "voice": voicePost,
     "voice_time":voice_time,
     "visibility":visibility,
     "hashtags": getHashtag(hashtag: hashtags),
     "is_have_comment": isHaveComment,
     "is_have_chat": isHaveChat,
     "is_content_group": isHaveChatGroup,
   }:{
     "content": content,
     "visibility": visibility,
     "video": video,
     "hashtags": getHashtag(hashtag: hashtags),
     "is_have_comment": isHaveComment,"is_have_chat": isHaveChat,"is_content_group": isHaveChatGroup,
   };
    formData = FormData.fromMap(data);
    return await RemoteDataSource.request<CreatePostModel>(
      converter: (model) => CreatePostModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      // data:
      formData: formData,
      url: "${AppEndpoints.baseUrl}mobile/posts/store",
    );
  }

  @override
  Future<Result<CreateCommentModel>> editComments({
    required int idComments,
    required String content,
  })async {
    return await RemoteDataSource.request<CreateCommentModel>(
      converter: (model) => CreateCommentModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {
        "content": content,
      },
      url: "${AppEndpoints.baseUrl}mobile/comment/$idComments",
    );
  }
  @override
  Future<Result<GeneralModel>> deleteComments({
    required int idComments,
  })async {
    return await RemoteDataSource.request<GeneralModel>(
      converter: (model) => GeneralModel.fromJson(model),
      method: HttpMethod.DELETE,
      url: "${AppEndpoints.baseUrl}mobile/comment/$idComments/user/${DIManager.findDep<SharedPrefs>().getUserID()}/delete",
    );
  }
  @override
  Future<Result<DeletePost>> deletePost({
    required int idPost,
  })async {
    return await RemoteDataSource.request<DeletePost>(
      converter: (model) => DeletePost.fromJson(model),
      method: HttpMethod.DELETE,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}mobile/posts/delete/$idPost",
    );
  }
  @override
  Future<Result<GeneralModel>> editPost({
    required int idPost,
    required String content,
    String? background,
    String? video,
    required List<String>? hashtags,
    File? image,
    required String? type,
    required int? isHaveComment,
    required int? isHaveChat,
  }) async {
    FormData formData;
    var imagePost;
    if (image != null) {
      imagePost = type !='B'?'': await MultipartFile.fromFile(
        image.path ?? '',
        filename: basename(image.path ?? ''),
      );
    }

    Map<String,dynamic> data = type == "A"
        ? {
      "content": content,
      "background": background,
      "hashtags": getHashtag(hashtag: hashtags),
      "is_have_comment": isHaveComment,
      "is_have_chat": isHaveChat,
      "image": null,
      "video": null,
    }
        : type == "B"
        ? {
      "content": content,
      "image": imagePost,
      "background": null,
      "is_have_comment": isHaveComment,
      "is_have_chat": isHaveChat,
      "video": null,
      "hashtags": getHashtag(hashtag: hashtags),
    }
        : {
      "content": content,
      "video": video,
      "background": null,
      "is_have_comment": isHaveComment,
      "is_have_chat": isHaveChat,
      "image": null,
      "hashtags": getHashtag(hashtag: hashtags),
    };

    formData = FormData.fromMap(data);
    print(data);
    print(data);
    print(data);
    print(data);
    print(data);
    return await RemoteDataSource.request<GeneralModel>(
      converter: (model) => GeneralModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      formData: formData,
      url: "${AppEndpoints.baseUrl}mobile/posts/edit/$idPost",
    );
  }
  @override
  Future<Result<CreateCommentModel>> createComments({
    required String content,
    required int idPost,
  }) async {
    return await RemoteDataSource.request<CreateCommentModel>(
      converter: (model) => CreateCommentModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {
        "content": content,
      },
      url: "${AppEndpoints.baseUrl}mobile/posts/$idPost/comment",
    );
  }

  @override
  Future<Result<CommentsByIdPostsModel>> likeComments({
    required String idComment,
  }) async {
    return await RemoteDataSource.request<CommentsByIdPostsModel>(
      converter: (model) => CommentsByIdPostsModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}mobile/comments/$idComment/like",
    );
  }

  @override
  Future<Result<CommentsByIdPostsModel>> likePost({
    required int idPost,
  }) async {
    return await RemoteDataSource.request<CommentsByIdPostsModel>(
      converter: (model) => CommentsByIdPostsModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}mobile/posts/$idPost/like",
    );
  }

  @override
  Future<Result<CommentsByIdPostsModel>> getCommentsByIdPosts({
    required String idPost, required int page,
  }) async {
    return await RemoteDataSource.request<CommentsByIdPostsModel>(
      converter: (model) => CommentsByIdPostsModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}mobile/posts/$idPost/comments?page=$page",
    );
  }

  @override
  Future<Result<CommunityPostUserModel>> getUserOrCompanyCommunityPost() async {
    return await RemoteDataSource.request<CommunityPostUserModel>(
      converter: (model) => CommunityPostUserModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      url: "${AppEndpoints.baseUrl}mobile/posts/user_posts",
    );
  }
  @override
  Future<Result<CommunityPostModel>> searchAllCommunityPostHashtag({required int page,required String hashtag}) async {
    return await RemoteDataSource.request<CommunityPostModel>(
      converter: (model) => CommunityPostModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {
        "hashtag": hashtag,
      },
      url: "${AppEndpoints.baseUrl}mobile/posts/search?page=$page",
    );
  }

  @override
  Future<Result<GeneralModel>> sendNotificationAddToGroup({
    required String userID,
}) async {
    return await RemoteDataSource.request<GeneralModel>(
      converter: (model) => GeneralModel.fromJson(model),
      method: HttpMethod.POST,
      data: {
        "user_id": userID,
        "title": 'موافقة',
        "message": "تم إضافتك إلى مجموعة دردشة",
      },
      url: "${AppEndpoints.baseUrl}mobile/send_notification_group",
    );
  }
  @override
  Future<Result<CommunityPostModel>> searchPostHashtag({required int page, String? hashtagId, String? content}) async {
    return await RemoteDataSource.request<CommunityPostModel>(
      converter: (model) => CommunityPostModel.fromJson(model),
      method: HttpMethod.POST,
      headers: {
        'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      },
      data: {
        "hashtag_id": hashtagId,
        "content": content,
      },
      url: "${AppEndpoints.baseUrl}mobile/posts/search_content?page=$page",
    );
  }
  @override
  Future<Result<CommunityPostModel>> getAllCommunityPost({required int page}) async {
    return await RemoteDataSource.request<CommunityPostModel>(
      converter: (model) => CommunityPostModel.fromJson(model),
      method: HttpMethod.GET,
      headers: DIManager.findDep<SharedPrefs>().getToken().toString() == "null"
          ? {RemoteDataSource.requiresToken: false}
          : {
              'Authorization':
                  'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
            },
      url: "${AppEndpoints.baseUrl}mobile/posts/get?page=$page",
    );
  }
}
