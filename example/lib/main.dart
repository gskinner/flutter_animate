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
      title: 'Flutter Animate Demo',
      debugShowCheckedModeBanner: false,
      home: FlutterAnimateExample(),
    );
  }
}

// this is a very quick and dirty example.
class FlutterAnimateExample extends StatelessWidget {
  const FlutterAnimateExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // a bit of a kitchen sink animated list example:
    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text("Super"),
        Text("Easy"),
        Text("Animated"),
        Text("Efffects"),
      ]
          .animate(
            interval: 1.seconds, // offset each item's start time
            onInit: (controller) => controller.repeat(), // loop
          )
          .shimmer( // the gradient effect on the text.
            delay: 900.ms,
            duration: 2.seconds,
            blendMode: BlendMode.srcIn, // use the child (ie. text) as a mask
            colors: [Colors.blue, Colors.yellow, Colors.transparent],
          )
          .scale(begin: 0.6, duration: 3.seconds, alignment: Alignment.bottomCenter) // inherits delay from previous
          .then() // set default delay to when the previous effect completes
          .fadeOut(duration: 1200.ms, curve: Curves.easeInQuad)
          .blur(begin: 0, end: 64)
          .slide(begin: Offset.zero, end: const Offset(0, -3))
          .scale(begin: 1, end: 4),
    );

    return Scaffold(
      body: DefaultTextStyle(
        style: const TextStyle(
          color: Color(0xFFFF2222),
          fontSize: 36,
          fontWeight: FontWeight.w900,
          height: 1.5,
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
