extension ListExtension<T> on List<T> {
  /// 조건 [condition] 에 따라 요소 [element] 를 추가합니다.
  void addIf(bool condition, T element) {
    if (condition) add(element);
  }
}