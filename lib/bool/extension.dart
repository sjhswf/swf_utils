extension BoolExtension on bool {
  /// 논리 자료형 [bool] 을 정수 자료형 [int] 로 변환합니다.
  int get toInt => this ? 1 : 0;
}