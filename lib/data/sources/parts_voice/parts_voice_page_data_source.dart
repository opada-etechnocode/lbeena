
import 'package:syrians_in_uae/data/models/parts_voice/parts_voice_model.dart';

import '../../../core/data_source/base_remote_data_source.dart';
import '../../../core/di/di_manager.dart';
import '../../../core/net/http_method.dart';
import '../../../core/results/result.dart';
import '../../../core/shared_prefs/shared_prefs.dart';
import '../../../core/utils/endpoints.dart';
import '../../models/auth/otp/otp_model.dart';
import '../../models/parts_voice/voices_model.dart';
import '../../models/radio_model/details_playList_model.dart';
import '../../models/radio_model/playList_model.dart';

abstract class PartsVoiceDataSource {
  const PartsVoiceDataSource();
  Future<Result<PartsVoiceModel>> getPartsVoices();
  Future<Result<VoicesModel>> getVoicesById({
    required int partsId,
    required int page,
  });

  Future<Result<List<PlayListModel>>> getPlayList();
  Future<Result<List<DetailsPlayListModel>>> getDetailsPlayList({
    required int id
  });
}

class PartsVoiceDataSourceImpl implements PartsVoiceDataSource {
  const PartsVoiceDataSourceImpl();

  @override
  Future<Result<PartsVoiceModel>> getPartsVoices() async {
    return await RemoteDataSource.request<PartsVoiceModel>(
      converter: (model) => PartsVoiceModel.fromJson(model),
      method: HttpMethod.GET,
      // headers: {
      //   'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      // },
      url: "${AppEndpoints.baseUrl}mobile/get_category_selection",
    );
  }



  @override
  Future<Result<List<PlayListModel>>> getPlayList() async {
    return await RemoteDataSource.request<List<PlayListModel>>(
      converter: (model) => PlayListModel.fromJsonList(model as List),
      method: HttpMethod.GET,
      headers: {
        "Authorization":'Bearer 4ab16008e0a3a062:5e0ddb92a78e14348ffe2d62d78083c2',
        "accept":'application/json',
      },
      url: "https://a8.asurahosting.com/api/station/420/playlists",
    );
  }



  @override
  Future<Result<List<DetailsPlayListModel>>> getDetailsPlayList({
    required int id
}) async {
    return await RemoteDataSource.request<List<DetailsPlayListModel>>(
      converter: (model) => DetailsPlayListModel.fromJsonList(model as List),
      method: HttpMethod.GET,
      headers: {
        "Authorization":'Bearer 4ab16008e0a3a062:5e0ddb92a78e14348ffe2d62d78083c2',
        "accept":'application/json',
      },
      url: "https://a8.asurahosting.com/api/station/420/playlist/$id/queue",
    );
  }



  @override
  Future<Result<VoicesModel>> getVoicesById({
    required int partsId,
    required int page,
}) async {
    return await RemoteDataSource.request<VoicesModel>(
      converter: (model) => VoicesModel.fromJson(model),
      method: HttpMethod.POST,
      // headers: {
      //   'Authorization': 'Bearer ${DIManager.findDep<SharedPrefs>().getToken()}'
      // },
      data: {
        "hashtag_voice_selection_id":partsId
      },
      queryParameters: {
        "page":page,
      },
      url: "${AppEndpoints.baseUrl}mobile/get_voice_selection",
    );
  }
}
