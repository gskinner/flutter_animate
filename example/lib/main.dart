import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: FlutterAnimateExample(),
    );
  }
}

// this is a very quick and dirty example.
class FlutterAnimateExample extends StatelessWidget {
  const FlutterAnimateExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simple animated list example:
    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text("Better"),
        Text("example"),
        Text("coming"),
        Text("soon!"),
      ].animate(interval: 250.ms).fadeIn(curve: Curves.easeOut).slide(),
    );

    // simple example of a custom effect + a onComplete handler:
    content = content
        .animate(onComplete: (controller) => controller.repeat(reverse: true))
        .custom(
          delay: 1000.ms,
          duration: 1000.ms,
          curve: Curves.easeInOut,
          builder: (_, value, child) => Container(
            color: Color.lerp(
              const Color(0xFF111111),
              const Color(0xFF333322),
              value,
            ),
            child: Center(child: child),
          ),
        )
        .scale(begin: 1, end: 1.5)
        .blur(end: 32);

    // add a looping shine effect:
    content = content
        .animate(onInit: (controller) => controller.repeat())
        .shine(delay: 3000.ms, duration: 1000.ms, curve: Curves.easeIn);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Animate Example"),
      ),
      body: DefaultTextStyle(
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 36,
          fontWeight: FontWeight.w900,
          height: 2,
        ),
        child: content,
      ),
    );
  }
}
