import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/di_manager.dart';
import '../../../../core/shared_prefs/shared_prefs.dart';
import '../../../../data/models/sp_today/sp_today_snapshot_model.dart';
import 'exchange_rates_state.dart';

class ExchangeRatesCubit extends Cubit<ExchangeRatesState> {
  ExchangeRatesCubit() : super(ExchangeRatesInitial());

  static ExchangeRatesCubit get(context) => BlocProvider.of(context);

  static const snapshotUrl = 'https://sse.sp-today.com/snapshot';
  static const defaultMarket = 'damascus';
  static const defaultExtraCurrency = 'AED';

  static const markets = {
    'damascus': 'دمشق',
    'alhasakah': 'الحسكة',
  };

  static const featuredCurrencies = ['USD', 'EUR'];

  static const currencyNames = {
    'USD': 'دولار أمريكي',
    'EUR': 'يورو',
    'TRY': 'ليرة تركية',
    'SAR': 'ريال سعودي',
    'AED': 'درهم إماراتي',
    'EGP': 'جنيه مصري',
    'JOD': 'دينار أردني',
    'KWD': 'دينار كويتي',
    'GBP': 'جنيه إسترليني',
    'QAR': 'ريال قطري',
    'BHD': 'دينار بحريني',
    'IQD': 'دينار عراقي',
    'LYD': 'دينار ليبي',
    'OMR': 'ريال عماني',
    'CHF': 'فرنك سويسري',
    'CAD': 'دولار كندي',
    'AUD': 'دولار أسترالي',
    'SEK': 'كرونة سويدية',
    'NOK': 'كرونة نرويجية',
    'DKK': 'كرونة دنماركية',
    'MAD': 'درهم مغربي',
    'TND': 'دينار تونسي',
    'DZD': 'دينار جزائري',
    'RUB': 'روبل روسي',
    'MYR': 'رينغيت ماليزي',
    'BRL': 'ريال برازيلي',
    'NZD': 'دولار نيوزيلندي',
    'ZAR': 'راند جنوب أفريقيا',
    'SGD': 'دولار سنغافوري',
  };

  SpTodaySnapshotModel? snapshot;
  String market = defaultMarket;
  String extraCurrency = defaultExtraCurrency;

  List<String> get pickerCurrencies {
    return currencyNames.keys
        .where((code) => !featuredCurrencies.contains(code))
        .toList();
  }

  Future<void> loadSaved() {
    final prefs = DIManager.findDep<SharedPrefs>();
    market = prefs.getExchangeMarket();
    extraCurrency = prefs.getExtraCurrency();
    if (!markets.containsKey(market)) market = defaultMarket;
    if (!currencyNames.containsKey(extraCurrency) ||
        featuredCurrencies.contains(extraCurrency)) {
      extraCurrency = defaultExtraCurrency;
    }
    return getSnapshot();
  }

  Future<void> getSnapshot() async {
    try {
      emit(LoadingExchangeRatesState());
      final response = await Dio().get(
        snapshotUrl,
        options: Options(
          headers: {'Accept': 'application/json'},
          receiveTimeout: const Duration(seconds: 12),
        ),
      );
      final data = response.data;
      if (data is Map<String, dynamic> && data['ok'] == true) {
        snapshot = SpTodaySnapshotModel.fromJson(data);
        emit(SuccessExchangeRatesState(snapshot!));
      } else {
        emit(ErrorExchangeRatesState());
      }
    } catch (e, stack) {
      print('Error In ExchangeRatesCubit is : $e in $stack');
      if (snapshot != null) {
        emit(SuccessExchangeRatesState(snapshot!));
      } else {
        emit(ErrorExchangeRatesState());
      }
    }
  }

  void setMarket(String value) {
    if (!markets.containsKey(value)) return;
    market = value;
    DIManager.findDep<SharedPrefs>().setExchangeMarket(value);
    if (snapshot != null) {
      emit(SuccessExchangeRatesState(snapshot!));
    }
  }

  void setExtraCurrency(String value) {
    if (!currencyNames.containsKey(value)) return;
    extraCurrency = value;
    DIManager.findDep<SharedPrefs>().setExtraCurrency(value);
    if (snapshot != null) {
      emit(SuccessExchangeRatesState(snapshot!));
    }
  }
}
