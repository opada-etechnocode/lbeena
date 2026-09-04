import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../data/models/aladhan_time_model/aladhan_time_model.dart';
import '../../../../data/sources/home_page/home_page_data_source.dart';
import 'aladhan_time_state.dart';

class AladhanTimeCubit extends Cubit<AladhanTimeState> {
  AladhanTimeCubit() : super(AladhanTimeInitial());
  static AladhanTimeCubit get(context) => BlocProvider.of(context);

  AladhanTimeModel? aladhanTimeModel;

  /// Syrian cities — Egyptian General Authority of Survey (method 5).
  static const String defaultCity = 'دمشق';

  Map<String, Map<String, double>> prayerCitiesCoordinates = {
    'دمشق': {'lat': 33.5138, 'lon': 36.2765},
    'حلب': {'lat': 36.2021, 'lon': 37.1343},
    'حمص': {'lat': 34.7324, 'lon': 36.7137},
    'حماة': {'lat': 35.1318, 'lon': 36.7578},
    'اللاذقية': {'lat': 35.5317, 'lon': 35.7900},
    'طرطوس': {'lat': 34.8890, 'lon': 35.8866},
    'دير الزور': {'lat': 35.3360, 'lon': 40.1460},
    'الرقة': {'lat': 35.9594, 'lon': 39.0069},
    'الحسكة': {'lat': 36.5024, 'lon': 40.7470},
    'السويداء': {'lat': 32.7089, 'lon': 36.5695},
    'درعا': {'lat': 32.6189, 'lon': 36.1021},
    'إدلب': {'lat': 35.9306, 'lon': 36.6339},
  };

  Map<String, Map<String, double>> get uaeCitiesCoordinates =>
      prayerCitiesCoordinates;

  Future<void> getAladhanTime({
    required String latitude,
    required String longitude,
  }) async {
    HomePageDataSourceImpl allAdsData = const HomePageDataSourceImpl();
    try {
      emit(LoadingAladhanTimeState());
      var data = await allAdsData.getAladhanTime(
        latitude: latitude,
        longitude: longitude,
      );
      if (data.data != null) {
        aladhanTimeModel = data.data!;
        emit(SuccessAladhanTimeState(data.data!));
      } else {
        emit(ErrorAladhanTimeState());
      }
    } catch (e, stack) {
      print('Error In ErrorMyOrderState is : $e in $stack');
      emit(ErrorAladhanTimeState());
    }
  }

  void getPrayerTimes(String city) {
    var coordinates = prayerCitiesCoordinates[city];
    if (coordinates == null) {
      city = defaultCity;
      coordinates = prayerCitiesCoordinates[city];
    }
    DIManager.findDep<SharedPrefs>().setYourCountry(city);
    if (coordinates != null) {
      getAladhanTime(
        latitude: coordinates['lat']!.toString(),
        longitude: coordinates['lon']!.toString(),
      );
    }
  }
}
