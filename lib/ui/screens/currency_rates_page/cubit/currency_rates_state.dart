
import '../../../../data/models/currency_rates/currency_rates_model.dart';

abstract class CurrencyRatesState {}
 class GoldenPriceInitial extends CurrencyRatesState {}


class LoadingCurrencyRatesState extends CurrencyRatesState {

}
  class SuccessCurrencyRatesState extends CurrencyRatesState {
  final CurrencyRatesModel currencyRateModel;
  SuccessCurrencyRatesState(this.currencyRateModel);
}
class ErrorCurrencyRatesState extends CurrencyRatesState {

  ErrorCurrencyRatesState();
}

