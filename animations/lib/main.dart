import 'package:animations/flip_animation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Animations());
}

class Animations extends StatelessWidget {
  const Animations({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(backgroundColor: Colors.black),
      title: 'Flutter Animations',
      home: const FlipAnimation(),
    );
  }
}
