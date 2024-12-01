import 'dart:math';

import 'package:swf_utils/util.dart';

extension IntExtension on int {
  /// 정수 자료형 [int] 을 논리 자료형 [bool] 로 변환합니다.
  bool get toBool => this != 0;

  String get asCurrency => toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  static const String _unitsLessThanSip = '영일이삼사오육칠팔구';
  static const String _unitsLessThanMan = ' 십백천';
  static const String _unitsMoreThanMan = ' 만억조경해자';

  static const String _koreans = '금영일이삼사오육칠팔구십백천만억조경해자원정';
  static const String _koreansHanja = '金〇一二三四五六七八九十百千萬億兆京垓秭원整';
  static const String _koreansGajeunja = '金零壹貳參肆伍陸柒捌玖拾佰仟萬億兆京垓원秭';

  String get asKorean => toString().split('')
      .map((char) => _unitsLessThanSip[int.parse(char)]).join('');

  static String _convertToHanja(String korean, {bool gajeunja = false}) => korean.trim()
      .split('').map((char) => (gajeunja
      ? _koreansGajeunja
      : _koreansHanja)[_koreans.indexOf(char)]).join('');

  String asHanja({bool gajeunja = false}) => _convertToHanja(asKorean, gajeunja: gajeunja);

  String asKoreanWithUnits({bool ignoreIl = false}) {
    assert(this >= 0);

    String value = toString().reversed;
    List<String> resultList = [];

    for (int i = 0; i < value.length; i++) {
      String text = '';
      int index = int.parse(value[i]), s = i ~/ 4 * 4;
      var range = IntRange(s, min(s + 4, value.length));
      String fourDigits = value.substring(range.start, range.end);

      if (this == 0 || index > 0) text = _unitsLessThanSip[index] + _unitsLessThanMan[i % 4];
      if (i % 4 == 0 && int.parse(fourDigits).toBool) text += _unitsMoreThanMan[i ~/ 4];

      resultList.insert(0, text);
    }

    String result = '${resultList.join('').replaceAll(' ', '')} ';
    if (!ignoreIl) return result.trim();

    String pattern = '${_unitsLessThanSip[1]}(?![$_unitsMoreThanMan])';
    return result.replaceAllMapped(RegExp(pattern), (_) => '').trim();
  }

  String asKoreanCurrency({
    bool ignoreIl = false,
    String prefix = '금 ',
    String suffix = ' 원정',
  }) => '$prefix${asKoreanWithUnits(ignoreIl: ignoreIl)}$suffix';

  String asHanjaCurrency({
    bool gajeunja = true,
    bool ignoreIl = false,
    String prefix = '金 ',
    String suffix = ' 원整',
  }) => '$prefix${_convertToHanja(
    asKoreanWithUnits(ignoreIl: ignoreIl),
    gajeunja: gajeunja,
  )}$suffix';
}

extension NumListExtension on List<num> {
  /// 리스트의 요소를 모두 합산하여 반환합니다.
  num get sum => fold(0, (previous, element) => previous + element);

  /// 리스트의 요소들의 평균을 반환합니다.
  num get average => isEmpty ? 0 : sum / length;
}