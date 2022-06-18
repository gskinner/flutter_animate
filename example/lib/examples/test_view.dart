import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TestView extends StatelessWidget {
  const TestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        child: const Text("Hello World")
            .animate()
            .slide(curve: Curves.easeOutCubic)
            .fadeIn(),
      ),
    );
  }
}
