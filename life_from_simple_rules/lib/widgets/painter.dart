import 'package:flutter/material.dart';
import 'package:life_from_simple_rules/models/atom.dart';

class MyPainter extends CustomPainter {
  final List<Atom> atoms;

  MyPainter({required this.atoms}) : super();

  @override
  void paint(Canvas canvas, Size size) {
    for (var atom in atoms) {
      canvas.drawCircle(
        Offset(atom.position.dx, atom.position.dy),
        atom.radius,
        Paint()..color = atom.color,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
