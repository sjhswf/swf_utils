import 'package:swf_utils/util.dart';

/// 숫자 자료형 [num] 의 범위에 대한 다양한 기능을 제공합니다.
class _NumRange<T extends num> {
  final (T, T) range;
  final List<_NumRange<T>>? excludes;

  const _NumRange(T start, T end, {this.excludes})
      : range = (start, end), assert(start <= end);

  T get _zero => (T is int ? 0 : .0) as T;

  bool get _hasExcludes => excludes != null && excludes!.isNotEmpty;

  /// 최솟값을 반환합니다.
  T get start => range.$1;

  /// 최댓값을 반환합니다.
  T get end => range.$2;

  /// 최솟값과 최댓값의 차이를 반환합니다.
  T get difference {
    var d = end - start;
    return (T == int ? d.toInt() : d.toDouble()) as T;
  }

  /// 해당 범위의 길이를 반환합니다.
  T get length {
    if (!_hasExcludes) return difference;
    return subRanges.fold<T>(_zero, (sum, range) => sum + (range.difference) as T);
  }

  /// [num] 이 범위에 포함되는지 여부를 반환합니다.
  bool contains(T num) {
    if (num < start || num > end) return false;
    if (!_hasExcludes) return true;
    return !excludes!.any((e) => e.contains(num));
  }

  /// [excludes] 를 제외한 부분범위 리스트를 반환합니다.
  List<_NumRange<T>> get subRanges {
    if (!_hasExcludes) return [this];

    T currentStart = start;
    return excludes!.fold(<_NumRange<T>>[], (ranges, exclude) {
      if (exclude.start > currentStart) {
        ranges.add(_NumRange<T>(currentStart, exclude.start));
      }
      currentStart = exclude.end;
      return ranges;
    })..addIf(currentStart < end, _NumRange<T>(currentStart, end));
  }

  @override
  String toString() => 'NumRange($start, $end${_hasExcludes ? ', excludes: $excludes' : ''})';
}

/// 숫자 자료형 [num] 의 범위에 대한 다양한 기능을 제공합니다.
class NumRange extends _NumRange<num> {
  NumRange(super.start, super.end, {super.excludes});
}

/// 정수 자료형 [int] 의 범위에 대한 다양한 기능을 제공합니다.
class IntRange extends _NumRange<int> {
  IntRange(super.start, super.end, {super.excludes});
}

/// 실수 자료형 [double] 의 범위에 대한 다양한 기능을 제공합니다.
class DoubleRange extends _NumRange<double> {
  DoubleRange(super.start, super.end, {super.excludes});
}