import 'package:syrians_in_uae/core/data_source/base_remote_data_source.dart';
import 'package:syrians_in_uae/core/net/http_method.dart';
import 'package:syrians_in_uae/data/models/search/seach_model.dart';
import 'package:syrians_in_uae/core/utils/endpoints.dart';
import '../../../core/results/result.dart';

abstract class SearchDataSource {
  const SearchDataSource();

  Future<Result<SearchItemModel>> getItemSearch({ String? title,required int page,int? categoryId});

}

class SearchDataSourceImpl implements SearchDataSource {
  const SearchDataSourceImpl();

  @override
  Future<Result<SearchItemModel>> getItemSearch({ String? title,required int page,int? categoryId}) async {
    // FormData data = FormData.fromMap({
    //   "properties":formData,
    //   "category_id":categoryId
    // });
    // print('formdata: ${data.fields}');
    return await RemoteDataSource.request<SearchItemModel>(
      converter: (model) => SearchItemModel.fromJson(model),
      method: HttpMethod.POST,
      data:  {
        'search':title,
        'category_id':categoryId,
      },
      headers: {RemoteDataSource.requiresToken: false},
      url: AppEndpoints.baseUrl + AppEndpoints.searchUrl +'/ar?page=$page',
    );
  }


}
