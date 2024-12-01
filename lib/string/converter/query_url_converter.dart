enum _QueryUrlMatchingType {
  blank(' ', '_BLK'),
  hash('#', '_HS'),
  questionMark('?', '_QM'),
  ampersand('&', '_AMP'),
  slash('/', '_SL'),
  colon(':', '_COL'),
  equal('=', '_EQL'),
  percentMark('%', '_PM'),
  wave('~', '_WV');

  const _QueryUrlMatchingType(this.urlType, this.queryType);

  final String urlType;
  final String queryType;

  static String convertQueryToUrl(String text) {
    return _QueryUrlMatchingType.values.fold(text, (result, type) {
      return result.replaceAll(type.queryType, type.urlType);
    });
  }

  static String convertUrlToQuery(String text) {
    return _QueryUrlMatchingType.values.fold(text, (result, type) {
      return result.replaceAll(type.urlType, type.queryType);
    });
  }
}

class QueryUrlConverter {
  QueryUrlConverter(String value) : _value = value;

  final String _value;

  String get query => _QueryUrlMatchingType.convertUrlToQuery(_value);
  String get url => _QueryUrlMatchingType.convertQueryToUrl(_value);

  @override
  String toString() => 'QueryUrlConverter(\n  query: $query,\n  url: $url\n)';
}