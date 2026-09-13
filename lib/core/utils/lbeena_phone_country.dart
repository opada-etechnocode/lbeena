class LbeenaPhoneCountry {
  LbeenaPhoneCountry._();

  static const String defaultCode = '963';
  static const String defaultSelection = '+963';
  static const String phoneHint = '****0999';

  /// Only these countries appear in the picker.
  static const List<String> allowedIsoCodes = [
    'SY',
    'AE',
    'SA',
    'IQ',
    'JO',
    'LB',
    'EG',
    'QA',
    'KW',
    'BH',
    'OM',
  ];

  /// Pinned at the top of the country dialog. Syria first.
  static const List<String> favorites = [
    'SY',
  ];

  static const List<String> _knownCodes = [
    '971',
    '963',
    '966',
    '964',
    '962',
    '961',
    '974',
    '965',
    '973',
    '968',
    '20',
  ];

  static String digits(String? dialCode) {
    final value = (dialCode ?? defaultCode).trim();
    return value.startsWith('+') ? value.substring(1) : value;
  }

  /// Local national number only: digits, no spaces, no leading zero.
  static String normalizeLocal(String? local) {
    var value = (local ?? '').replaceAll(RegExp(r'\D'), '');
    if (value.startsWith('00')) {
      value = value.substring(2);
    }
    if (value.startsWith('0')) {
      value = value.substring(1);
    }
    return value;
  }

  static String full(String? countryCode, String? local) {
    return '${digits(countryCode)}${normalizeLocal(local)}';
  }

  static String detectFromFull(String? fullMobile) {
    if (fullMobile == null || fullMobile.isEmpty) return defaultCode;
    final sorted = [..._knownCodes]..sort((a, b) => b.length.compareTo(a.length));
    for (final code in sorted) {
      if (fullMobile.startsWith(code)) return code;
    }
    return defaultCode;
  }

  static String localFromFull(String? fullMobile) {
    if (fullMobile == null || fullMobile.isEmpty) return '';
    final code = detectFromFull(fullMobile);
    if (fullMobile.startsWith(code)) {
      return fullMobile.substring(code.length);
    }
    return fullMobile;
  }
}
