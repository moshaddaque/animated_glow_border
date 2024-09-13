import 'package:animated_glow_border/animated_glow_border.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Animated Glow Border Example'),
        ),
        body: Center(
          child: AnimatedGlowBorder(
            child: Container(
              width: 200,
              height: 200,
              alignment: Alignment.center,
              child: const Text(
                'Glow Border',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
