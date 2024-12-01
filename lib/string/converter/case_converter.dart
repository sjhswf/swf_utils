enum StringCaseType {
  lowerSnakeCase, upperSnakeCase,
  lowerSkewerCase, upperSkewerCase,
  pascalCase, camelCase,
  titleCase, lowerCase, upperCase;
}

class StringCaseConverter {
  StringCaseConverter(String value) {
    var type = getCaseType(value);
    switch (type) {
      case StringCaseType.lowerSnakeCase: lowerSnakeCase = value; break;
      case StringCaseType.upperSnakeCase: upperSnakeCase = value; break;
      case StringCaseType.lowerSkewerCase: lowerSkewerCase = value; break;
      case StringCaseType.upperSkewerCase: upperSkewerCase = value; break;
      case StringCaseType.pascalCase: pascalCase = value; break;
      case StringCaseType.camelCase: camelCase = value; break;
      case StringCaseType.titleCase: titleCase = value; break;
      case StringCaseType.lowerCase: lowerCase = value; break;
      case StringCaseType.upperCase: upperCase = value; break;
      default: throw ArgumentError('Unknown case type for: $value');
    }
  }

  /// default: lower_snake_case
  late String _value;

  /// lower_snake_case
  String get lowerSnakeCase => _value;
  set lowerSnakeCase(String s) => _value = s;

  /// UPPER_SNAKE_CASE
  String get upperSnakeCase => _value.toUpperCase();
  set upperSnakeCase(String s) => _value = s.toLowerCase();

  /// lower_skewer_case
  String get lowerSkewerCase => _value.replaceAll('_', '-');
  set lowerSkewerCase(String s) => _value = s.replaceAll('-', '_');

  /// UPPER_SKEWER_CASE
  String get upperSkewerCase => lowerSkewerCase.toUpperCase();
  set upperSkewerCase(String s) => lowerSkewerCase = s.toLowerCase();

  /// PascalCase
  String get pascalCase {
    final words = _splitToWords(_value);
    return words.map(_capitalizeFirstLetter).join();
  }
  set pascalCase(String s) {
    final words = _splitToWords(s);
    _value = words.map((word) => word.toLowerCase()).join('_');
  }

  /// camelCase
  String get camelCase {
    final words = _splitToWords(_value);
    return [words.first.toLowerCase(), ...words.skip(1).map(_capitalizeFirstLetter)].join();
  }
  set camelCase(String s) {
    final words = _splitToWords(s);
    _value = words.map((word) => word.toLowerCase()).join('_');
  }

  /// Title Case
  String get titleCase {
    final words = _splitToWords(_value.replaceAll('_', ' ').replaceAll('-', ' '));
    return words.map(_capitalizeFirstLetter).join(' ');
  }
  set titleCase(String s) {
    final words = s.split(RegExp(r'\s+'));
    _value = words.map((word) => word.toLowerCase()).join('_');
  }

  /// lower case
  String get lowerCase => titleCase.toLowerCase();
  set lowerCase(String s) => titleCase = s.toLowerCase();

  /// UPPER CASE
  String get upperCase => titleCase.toUpperCase();
  set upperCase(String s) => titleCase = s.toUpperCase();

  static StringCaseType getCaseType(String str) {
    var isLower = str == str.toLowerCase();
    var isUpper = str == str.toUpperCase();
    var hasUnderscore = str.contains('_');
    var hasHyphen = str.contains('-');
    var hasSpace = str.contains(' ');

    /// 모든 문자가 소문자
    if (isLower) {
      if (hasUnderscore) return StringCaseType.lowerSnakeCase;
      if (hasHyphen) return StringCaseType.lowerSkewerCase;
      return StringCaseType.lowerCase;
    }

    /// 모든 문자가 대문자
    else if (isUpper) {
      if (hasUnderscore) return StringCaseType.upperSnakeCase;
      if (hasHyphen) return StringCaseType.upperSkewerCase;
      return StringCaseType.upperCase;
    }

    /// 소문자와 대문자가 섞임
    else {
      var firstChar = str[0];
      var isFirstCharUpper = firstChar.toUpperCase() == firstChar;
      var isFirstCharLower = firstChar.toLowerCase() == firstChar;
      if (hasSpace) return StringCaseType.titleCase;
      if (isFirstCharUpper && !hasUnderscore && !hasHyphen) return StringCaseType.pascalCase;
      if (isFirstCharLower && !hasUnderscore && !hasHyphen) return StringCaseType.camelCase;
    }

    throw ArgumentError('Unknown case type for: $str');
  }

  static List<String> _splitToWords(String str) {
    final pattern = RegExp(r'[A-Z]?[a-z]+|[A-Z]+(?=[A-Z][a-z]|$)|\d+');
    final matches = pattern.allMatches(str.replaceAll(RegExp(r'[-_]'), ' '));
    return matches.map((m) => m.group(0) ?? '').toList();
  }

  static String _capitalizeFirstLetter(String str) {
    if (str.isEmpty) return str;
    return str[0].toUpperCase() + str.substring(1).toLowerCase();
  }
}