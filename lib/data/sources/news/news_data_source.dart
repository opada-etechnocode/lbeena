import 'package:syrians_in_uae/data/models/auth/otp/otp_model.dart';
import 'package:syrians_in_uae/data/models/chats/message_model.dart';
import 'package:syrians_in_uae/data/models/news/news_model.dart';

import '../../../core/data_source/base_remote_data_source.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/net/http_method.dart';
import '../../../core/results/result.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../models/news/new_item.dart';
import '../../models/news/news_related_model.dart';
import '../../models/notifications/all_notifications_model.dart';
import '../../models/notifications/send_notifications_to_user.dart';
import '../../../core/utils/endpoints.dart';

abstract class NewsDataSource{
  const NewsDataSource();

  Future<Result<NewsModel>> getAllNews({required page});
  Future<Result<RelatedNewsModel>> getRelatedNewsModel({
    required int idNew,
});
  Future<Result<NewsModel>> getSearchNews({
    required String title, required int page,
});
  Future<Result<NewItemModel>> getItemNews({
    required int idNew,
});


}

class NewsDataSourceImpl implements NewsDataSource{
  const NewsDataSourceImpl();

  @override
  Future<Result<RelatedNewsModel>> getRelatedNewsModel({
    required int idNew,
  })async {
    return await RemoteDataSource.request<RelatedNewsModel>(
      converter: (model) => RelatedNewsModel.fromJson(model),
      method: HttpMethod.POST,
      data: {
        "news_id":idNew
      },
      headers: {RemoteDataSource.requiresToken: false},
      url: "${AppEndpoints.baseUrl}mobile/news/related_news",
    );
  }
  @override
  Future<Result<NewsModel>> getAllNews({required page})async {
    return await RemoteDataSource.request<NewsModel>(
      converter: (model) => NewsModel.fromJson(model),
      method: HttpMethod.GET,
    headers: {RemoteDataSource.requiresToken: false},
      url: "${AppEndpoints.baseUrl}mobile/news/get?page=$page",
    );
  }


  @override
  Future<Result<NewsModel>> getSearchNews({
  required String title, required int page,
})async {
    return await RemoteDataSource.request<NewsModel>(
      converter: (model) => NewsModel.fromJson(model),
      method: HttpMethod.GET,
      data: {
        "value":title
      },
      headers: {RemoteDataSource.requiresToken: false},
      url: "${AppEndpoints.baseUrl}mobile/news/search?page=$page",
    );
  }
  @override
  Future<Result<NewItemModel>> getItemNews({
    required int idNew,
  })async {
    return await RemoteDataSource.request<NewItemModel>(
      converter: (model) => NewItemModel.fromJson(model),
      method: HttpMethod.GET,
      headers: {RemoteDataSource.requiresToken: false},
      url: "${AppEndpoints.baseUrl}mobile/news/get/$idNew",
    );
  }



}