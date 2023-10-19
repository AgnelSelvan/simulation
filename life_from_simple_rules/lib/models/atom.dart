import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Atom extends Equatable {
  final Offset position;
  final Color color;
  final Offset velocity;
  final int id;
  final double radius;
  final double speed;

  const Atom({
    required this.position,
    required this.color,
    required this.id,
    required this.radius,
    this.velocity = Offset.zero,
    required this.speed,
  });

  Atom copyWith({
    Offset? position,
    Color? color,
    Offset? velocity,
    double? radius,
    double? speed,
  }) {
    return Atom(
      id: id,
      position: position ?? this.position,
      color: color ?? this.color,
      velocity: velocity ?? this.velocity,
      radius: radius ?? this.radius,
      speed: speed ?? this.speed,
    );
  }

  @override
  int get hashCode => position.hashCode ^ color.hashCode;

  @override
  List<Object?> get props => [id];
}
