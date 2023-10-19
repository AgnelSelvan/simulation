import 'package:flutter/material.dart';
import 'package:life_from_simple_rules/models/atom.dart';

extension ListUpdate<T> on List<T> {
  List<T> update(int pos, T t) {
    List<T> list = [];
    list.add(t);
    replaceRange(pos, pos + 1, list);
    return this;
  }
}

extension AtomFeature on List<Atom> {
  List<Atom> get redAtom {
    try {
      return where((element) => element.color == Colors.red).toList();
    } catch (e) {
      return [];
    }
  }

  List<Atom> get yellowAtom =>
      where((element) => element.color == Colors.yellow).toList();

  List<Atom> get greenAtom =>
      where((element) => element.color == Colors.green).toList();
}
