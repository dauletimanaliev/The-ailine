import 'package:flutter/material.dart';
import 'package:gghgggfsfs/presentation/client/map_home_screen.dart';

void main() {
  runApp(const AilineApp());
}

class AilineApp extends StatelessWidget {
  const AilineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ailine',
      home: MapHomeScreen(),
    );
  }
}
