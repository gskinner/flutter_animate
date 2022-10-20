import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AdapterView extends StatelessWidget {
  const AdapterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // example of driving an animation with a ValueNotifier

    // create the ValueNotifier:
    ValueNotifier<double> notifier = ValueNotifier(0);

    // create an overly elaborate animation using ValueNotifierAdapter,
    // and wire up a Slider to update the ValueNotifier
    Widget panel = Container(
      color: const Color(0xFF2A2B2F),
      child: Column(children: [
        const SizedBox(height: 32),
        const Text(
          'Slider Driven Animation',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
          textAlign: TextAlign.center,
        )
            .animate(adapter: ValueNotifierAdapter(notifier))
            .blurXY(end: 16)
            .scaleXY(begin: 1, end: 2)
            .tint(color: const Color(0xFF80DDFF))
            .fadeOut(curve: Curves.easeInExpo),

        // Slider:
        AnimatedBuilder(
          animation: notifier,
          builder: (_, __) => Slider(
            activeColor: const Color(0xFF80DDFF),
            value: notifier.value,
            onChanged: (value) => notifier.value = value,
          ),
        )
      ]),
    );

    // example driving animations with a ScrollController

    // create the scroll controller:
    ScrollController scrollController = ScrollController();

    // create some dummy items for the list:
    List<Widget> items = [
      const Text(
        'Scroll driven animation',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      )
    ];
    for (int i = 0; i < 100; i++) {
      items.add(Text('item $i', style: const TextStyle(height: 2.5)));
    }
    // layer the indicators under the list, and assign the ScrollController to
    // the list, and both animations (via ScrollAdapter):
    Widget list = Stack(
      children: [
        Container(
          height: 64,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x8080DDFF), Colors.transparent]),
          ),
        )
            .animate(
              adapter: ScrollAdapter(
                scrollController,
                end: 500, // end 500px into the scroll
                animated: true, // smooth the animation
              ),
            )
            .fadeIn(),

        // bottom indicator:
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 64,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0x8080DDFF), Colors.transparent],
              ),
            ),
          )
              .animate(
                adapter: ScrollAdapter(
                  scrollController,
                  begin: -500, // begin 500px before the end of the scroll
                  animated: true, // smooth the animation
                ),
              )
              .fadeOut(),
        ),

        // the list (with the scrollController assigned):
        ListView(
          padding: const EdgeInsets.all(24.0),
          controller: scrollController,
          children: items,
        ),
      ],
    );

    return Column(
      children: [
        panel,
        Flexible(child: list),
      ],
    );
  }
}
