import 'package:flutter/material.dart';
import 'package:life_from_simple_rules/screens/home.dart';

class ParticleApp extends StatelessWidget {
  const ParticleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const ParticleScreen(),
    );
  }
}
