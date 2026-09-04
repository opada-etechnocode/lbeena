import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../data/models/fortune_wheel/fortune_wheel_cutomer.dart';
import '../../../../data/sources/home_page/home_page_data_source.dart';
import 'fortune_wheel_state.dart';

class FortuneWheelCubit extends Cubit<FortuneWheelState> {
  FortuneWheelCubit() : super(FortuneWheelInitial());

  static FortuneWheelCubit get(context) => BlocProvider.of(context);

  List? fortuneWheelList =  DIManager.findDep<SharedPrefs>().getListFortuneWheel();
  StreamController<int> controller = StreamController<int>.broadcast();
  Stream<int> get selectedStream => controller.stream;

  void addNameToList({required String name}) {

    fortuneWheelList!.add(name);
    DIManager.findDep<SharedPrefs>().setListFortuneWheel(fortuneWheelList!);
    emit(FortuneWheelStateSuccess());
  }
  void removeNameToList({required String name}) {
    fortuneWheelList!.remove(name);
    DIManager.findDep<SharedPrefs>().setListFortuneWheel(fortuneWheelList!);
    emit(FortuneWheelStateSuccess());
  }

  void addAllToList({required List value}) {
    fortuneWheelList!.addAll(value);
    DIManager.findDep<SharedPrefs>().setListFortuneWheel(fortuneWheelList!);
    emit(FortuneWheelStateSuccess());
  }
    void clearList() {
      fortuneWheelList = ["Mahmoud","Ali","Raghad"];
      valueCustomerId.clear();
      DIManager.findDep<SharedPrefs>().setListFortuneCustomerId([]);
      DIManager.findDep<SharedPrefs>().setListFortuneWheel(fortuneWheelList!);
    emit(FortuneWheelStateSuccess());
  }

  List<FortuneWheelCustomerList> fortuneWheelCustomerList=[];
  List valueCustomerId =[];
  Future<void> getFortuneWheelCustomer() async {
    HomePageDataSourceImpl allAdsData = const HomePageDataSourceImpl();
    try {
      emit(FortuneWheelCustomerStateLoading());
      var data = await allAdsData.getFortuneWheelCustomer();
      if (data.data != null) {

        emit(FortuneWheelCustomerStateSuccess(data.data!));
      } else {
        emit(FortuneWheelCustomerStateError(data.data!.message??''));
      }
    } catch (e, stack) {
      print("Error In ErrorMyOrderState is : $e in $stack");
      emit(FortuneWheelCustomerStateError(e.toString()));
    }
  }
  int? lastSelectedIndex; // تخزين آخر رقم تم اختياره

  void spinWheel() {
    int randomIndex;
    do {
      randomIndex = Random().nextInt(fortuneWheelList!.length);
    } while (randomIndex == lastSelectedIndex); // التأكد من أن الرقم الجديد مختلف

    lastSelectedIndex = randomIndex;
    controller.add(randomIndex); // إرسال القيمة الجديدة للعجلة
    emit(SpinWheelStateSuccess());
  }
}
