class CurrencyRatesModel {
  CurrencyRatesModel({
    required this.result,
    required this.documentation,
    required this.termsOfUse,
    required this.timeLastUpdateUnix,
    required this.timeLastUpdateUtc,
    required this.timeNextUpdateUnix,
    required this.timeNextUpdateUtc,
    required this.baseCode,
    required this.conversionRates,
  });

  final String? result;
  final String? documentation;
  final String? termsOfUse;
  final int? timeLastUpdateUnix;
  final String? timeLastUpdateUtc;
  final int? timeNextUpdateUnix;
  final String? timeNextUpdateUtc;
  final String? baseCode;
  final Map<String, double> conversionRates;

  factory CurrencyRatesModel.fromJson(Map<String, dynamic> json) {
    return CurrencyRatesModel(
      result: json["result"],
      documentation: json["documentation"],
      termsOfUse: json["terms_of_use"],
      timeLastUpdateUnix: json["time_last_update_unix"],
      timeLastUpdateUtc: json["time_last_update_utc"],
      timeNextUpdateUnix: json["time_next_update_unix"],
      timeNextUpdateUtc: json["time_next_update_utc"],
      baseCode: json["base_code"],
      conversionRates: Map.from(json["conversion_rates"])
          .map((k, v) => MapEntry<String, double>(k, (v as num).toDouble())),
    );
  }
}
