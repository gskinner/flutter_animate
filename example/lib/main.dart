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

    // add a looping shimmer effect:
    content = content.animate(onInit: (c) => c.repeat(reverse: true)).shimmer(
      delay: 500.ms,
      duration: 1000.ms,
      colors: [Colors.yellow, Colors.blue, Colors.black, Colors.yellow],
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Animate Example"),
      ),
      body: DefaultTextStyle(
        style: const TextStyle(
          color: Color(0xFF222222),
          fontSize: 36,
          fontWeight: FontWeight.w900,
          height: 2,
        ),
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: content,
        ),
      ),
    );
  }
}
