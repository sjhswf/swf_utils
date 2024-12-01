import 'package:swf_utils/util.dart';

extension StringExtension on String {
  String get reversed => split('').reversed.join('');
}

extension HangeulExtension on String {
  static const _cho = 'ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ';
  static const _jung = 'ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ';
  static const _jong = ' ㄱㄲㄳㄴㄵㄶㄷㄹㄺㄻㄼㄽㄾㄿㅀㅁㅂㅄㅅㅆㅇㅈㅊㅋㅌㅍㅎ';

  int get _index => runes.last - 0xAC00;
  String get _choseong { assert(length == 1); return _cho[_index ~/ 588]; }
  String get _jungseong { assert(length == 1); return _jung[(_index % 588) ~/ 28]; }
  String get _jongseong { assert(length == 1); return _jong[_index % 28]; }

  String get choseong => split('').map((e) => e._choseong).join('');
  String get jungseong => split('').map((e) => e._jungseong).join('');
  String get jongseong => split('').map((e) => e._jongseong).join('');

  bool get hasBatchim { assert(length == 1 && isEumjeol); return _jongseong != ' '; }
  String get _puleossugi {
    assert(length == 1);
    if (isJaeum || isMoeum) return this;
    return ([_choseong, _jungseong]..addIf(hasBatchim, _jongseong)).join('');
  }
  String get _moassugi {
    final cho = _cho.indexOf(this[0]);
    final jung = _jung.indexOf(this[1]);
    final jong = _jong.indexOf(length == 3 ? this[2] : ' ');
    if (cho == -1 || jung == -1) return '';
    return String.fromCharCode(0xAC00 + cho * 588 + jung * 28 + jong);
  }

  String get puleossugi => split('').map((e) => e._puleossugi).join('');

  String get moassugi {
    List<(String, bool)> list = split('').map<(String, bool)>((e) => (e, e.isJaeum)).toList();
    List<String> result = [], char = [];
    bool moeumFlag = false;

    for (var entry in list.reversed) {
      char.insert(0, entry.$1);
      if (entry.$2) {
        if (moeumFlag) {
          result.insert(0, char.join('')._moassugi);
          char.clear();
          moeumFlag = false;
        }
        continue;
      }
      moeumFlag = true;
    }

    return result.join('');
  }

  String get last => this[length - 1];
  String get eunNeun => last.hasBatchim ? '은' : '는';
  String get eunNeunName => last.hasBatchim ? '이는' : '는';
  String get iGa => last.hasBatchim ? '이' : '가';
  String get iGaName => last.hasBatchim ? '이가' : '가';
  String get eulReul => last.hasBatchim ? '을' : '를';
  String get eulReulName => last.hasBatchim ? '이를' : '를';
  String get roEuro => last.hasBatchim ? '으로' : '로';
  String get withEunNeun => this + eunNeun;
  String get withEunNeunName => this + eunNeunName;
  String get withIGa => this + iGa;
  String get withIGaName => this + iGaName;
  String get withEulReul => this + eulReul;
  String get withEulReulName => this + eulReulName;
  String get withRoEuro => this + roEuro;

  bool get isJaeum { assert(length == 1); return IntRange(12593, 12622).contains(codeUnits[0]); }
  bool get isMoeum { assert(length == 1); return IntRange(12623, 12643).contains(codeUnits[0]); }
  bool get isEumjeol { assert(length == 1); return IntRange(44032, 55203).contains(codeUnits[0]); }
  bool get _isHangeul { assert(length == 1); return isJaeum || isMoeum || isEumjeol; }

  bool get isHangeul => split('').every((e) => e._isHangeul || e == ' ');
  bool get hasHangeul => split('').any((char) => char.isHangeul);
  bool get hasSeparatedJaeumOrMoeum => split('').map((e) => e.isJaeum || e.isMoeum).contains(true);

  bool containsHangeul(String other) => puleossugi.contains(other.puleossugi);
}