import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swf_utils/bool/extension.dart';
import 'package:swf_utils/date_time/enum.dart';

DateTime get _now => DateTime.now();

extension DateTimeExtension on DateTime {
  /// Firebase 시간 사용 형식 [Timestamp] 으로 변환합니다.
  Timestamp get toTimestamp => Timestamp.fromDate(this);

  /// [DateTime] 의 시간부를 제외합니다.
  /// 2024.11.28 17:46:42 -> 2024.11.28 00:00:00
  DateTime get ignoreTime => DateTime(year, month, day);

  /// 해당 시간에 태어난 사람의 만 나이를 계산합니다.
  /// ex. 2000.01.01 -> 25 [2025년 기준]
  int get age {
    int error = (_now.month < month || (_now.month == month && _now.day < day)).toInt;
    return _now.year - year - error;
  }

  /// 해당 시간에 태어난 사람의 세대를 계산합니다.
  /// ex. 23[세] -> 20[대], 56[세] -> 50[대]
  int get generation => age ~/ 10 * 10;

  ///
  Weekday get wd => Weekday.values[weekday - 1];
}
