import 'dart:developer';
import '../../../../core/errors/unexpected_error.dart';
import '../../../../core/results/result.dart';
import 'models/base_entity.dart';
import 'models/base_models.dart';

abstract class BaseRepository {
  const BaseRepository();
  Future<Result<ENTITY>>
      mapModelToEntity<ENTITY extends BaseEntity, MODEL extends BaseModel>(
    Result<MODEL?> data,
  ) async {
    try {
      if (data.hasDataOnly) {
        return Result(data: data.data!.toEntity() as ENTITY);
      } else {
        return Result(error: data.error);
      }
    } catch (e) {
      log('err $e');
      return Result(error: data.error);
    }
  }

  /// it returns [List] of [ENTITY] wrapped inside [Result] data
  Future<Result<List<ENTITY>>>
      mapModelsToEntities<ENTITY extends BaseEntity, MODEL extends BaseModel>(
    Result<List<MODEL?>?> data,
  ) async {
    try {
      if (data.hasDataOnly) {
        return Result(
          data:
              data.data?.map<ENTITY>((e) => e?.toEntity() as ENTITY).toList() ??
                  [],
        );
      } else
        return Result(error: data.error);
    } catch (e, s) {
      log('mapModelListToEntityList error is  : $e |\n $s');
      return Result(error: data.error);
    }
  }

  /// This method simulate fake request with 50% chance of failure and 50% chance of success
  /// it returns [Result] with [RESULT_MODEL] data
  Future<Result<RESULT_MODEL>> fakeRequest<RESULT_MODEL>(
      RESULT_MODEL data) async {
  //  await Future.delayed(Duration(seconds: 2));
   // final isConnected = await ConnectionVerify.connectionStatus();
    // final bool isSuccess = Random().nextBool();
    //if (isConnected) {
      return Result(data: data);
    // } else {
    //   return Result(error: NetError());
    // }
  }

  /// This method simulate fake request with 50% chance of failure and 50% chance of success
  /// it returns [Result] with [RESULT_MODEL] data
  Future<Result<RESULT_MODEL>> requestDataSource<RESULT_MODEL>(
      Future<RESULT_MODEL> Function() fun) async {
    await Future.delayed(Duration(seconds: 2));
    try {
        return Result(data: await fun());
    } catch (e, s) {
      print(e);
      print(s);
      return Result(error: UnExpectedError());
    }
  }

  // /// This method simulate fake request with 50% chance of failure and 50% chance of success
  // /// it returns [Result] with [RESULT_ENTITY] data
  // Future<RESULT_ENTITY> mapModelToEntity<RESULT_ENTITY extends BaseEntity>(
  //     Result<BaseModel> model) async {
  //   try {
  //     if (model.hasDataOnly) model.data!.toEntity();
  //     return Result(data: model.data!.toEntity());
  //   } catch (e, s) {
  //     print(e);
  //     print(s);
  //     return Result(error: UnExpectedError());
  //   }
  // }
}
