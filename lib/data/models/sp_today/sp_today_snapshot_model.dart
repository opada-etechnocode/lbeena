class SpTodayQuote {
  const SpTodayQuote({
    required this.buy,
    required this.sell,
    required this.change,
  });

  final num buy;
  final num sell;
  final num change;

  factory SpTodayQuote.fromJson(Map<String, dynamic>? json) {
    return SpTodayQuote(
      buy: json?['buy'] as num? ?? 0,
      sell: json?['sell'] as num? ?? 0,
      change: json?['change'] as num? ?? 0,
    );
  }
}

class SpTodaySnapshotModel {
  SpTodaySnapshotModel({
    required this.currencies,
    required this.gold,
    required this.version,
  });

  final Map<String, SpTodayQuote> currencies;
  final Map<String, SpTodayQuote> gold;
  final int? version;

  factory SpTodaySnapshotModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return SpTodaySnapshotModel(
      currencies: _parseQuotes(data['currencies']),
      gold: _parseQuotes(data['gold']),
      version: data['version'] as int?,
    );
  }

  static Map<String, SpTodayQuote> _parseQuotes(dynamic raw) {
    if (raw is! Map) return {};
    return raw.map((key, value) {
      return MapEntry(
        key.toString(),
        SpTodayQuote.fromJson(
          value is Map<String, dynamic> ? value : null,
        ),
      );
    });
  }

  SpTodayQuote? currency(String code, String market) {
    return currencies['$code:$market'];
  }

  SpTodayQuote? goldKarat(String karat, String market) {
    return gold['$karat:$market'];
  }
}
