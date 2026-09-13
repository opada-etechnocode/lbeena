import '../../../../data/models/sp_today/sp_today_snapshot_model.dart';

abstract class ExchangeRatesState {}

class ExchangeRatesInitial extends ExchangeRatesState {}

class LoadingExchangeRatesState extends ExchangeRatesState {}

class SuccessExchangeRatesState extends ExchangeRatesState {
  SuccessExchangeRatesState(this.snapshot);

  final SpTodaySnapshotModel snapshot;
}

class ErrorExchangeRatesState extends ExchangeRatesState {}
