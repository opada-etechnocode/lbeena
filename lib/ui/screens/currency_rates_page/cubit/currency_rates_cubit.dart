import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/currency_rates/currency_rates_model.dart';
import '../../../../data/sources/home_page/home_page_data_source.dart';
import 'currency_rates_state.dart';


class CurrencyRatesCubit extends Cubit<CurrencyRatesState> {
  CurrencyRatesCubit() : super(GoldenPriceInitial());
  static CurrencyRatesCubit get(context) => BlocProvider.of(context);

  /// get Golden Price

  CurrencyRatesModel? goldenPriceModel;
  Future<void> getCurrencyRates() async {
    HomePageDataSourceImpl allAdsData = const HomePageDataSourceImpl();
    try {
        emit(LoadingCurrencyRatesState());
      var data = await allAdsData.getCurrencyRates();
      if (data.data != null) {
        goldenPriceModel =data.data!;
        emit(SuccessCurrencyRatesState(data.data!));
      } else {
        emit(ErrorCurrencyRatesState());
      }
    } catch (e, stack) {
      print("Error In ErrorCurrencyRatesState is : $e in $stack");
      emit(ErrorCurrencyRatesState());
    }
  }
}
