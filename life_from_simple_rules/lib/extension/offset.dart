import 'package:flutter/material.dart';

extension OffsetExt on Offset {
  Offset copyWith({double? dx, double? dy}) {
    return Offset(dx ?? this.dx, dy ?? this.dy);
  }
}
