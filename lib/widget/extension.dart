import 'package:flutter/material.dart';

extension WidgetAlignExtension on Widget {
  Widget get fill => Positioned.fill(child: this);
  Widget get center => Align(alignment: Alignment.center, child: this);
  Widget get topLeft => Align(alignment: Alignment.topLeft, child: this);
  Widget get topRight => Align(alignment: Alignment.topRight, child: this);
  Widget get bottomLeft => Align(alignment: Alignment.bottomLeft, child: this);
  Widget get bottomRight => Align(alignment: Alignment.bottomRight, child: this);
  Widget get topCenter => Align(alignment: Alignment.topCenter, child: this);
  Widget get bottomCenter => Align(alignment: Alignment.bottomCenter, child: this);
  Widget get leftCenter => Align(alignment: Alignment.centerLeft, child: this);
  Widget get rightCenter => Align(alignment: Alignment.centerRight, child: this);
}

extension IterableWidgetExtension on Iterable<Widget> {
  List<Widget> _separateWidgets(Widget separator) {
    final widgets = toList();
    if (widgets.isEmpty) return widgets;

    return [
      for (int i = 0; i < widgets.length; i++) ...[
        widgets[i], if (i < widgets.length - 1) separator,
      ],
    ];
  }

  /// 위젯 사이에 가로 방향 구분자를 추가하여 반환합니다.
  List<Widget> separateW({double? interval, Widget? separator}) {
    assert(interval != null && separator != null);
    return _separateWidgets(separator ?? SizedBox(width: interval ?? 8.0));
  }

  /// 위젯 사이에 세로 방향 구분자를 추가하여 반환합니다.
  List<Widget> separateH({double? interval, Widget? separator}) {
    assert(interval != null && separator != null);
    return _separateWidgets(separator ?? SizedBox(height: interval ?? 8.0));
  }
}
