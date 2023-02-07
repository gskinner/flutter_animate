import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AdapterView extends StatelessWidget {
  const AdapterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // example of driving an animation with a ValueNotifier

    // create the ValueNotifier:
    ValueNotifier<double> notifier = ValueNotifier(0);

    // create an animation driven by ValueNotifierAdapter,
    // and wire up a Slider to update the ValueNotifier
    Widget panel = Container(
      color: const Color(0xFF2A2B2F),
      child: Column(children: [
        const SizedBox(height: 32),
        const Text(
          'Slider Driven Animation',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
          textAlign: TextAlign.center,
        )
            .animate(adapter: ValueNotifierAdapter(notifier, animated: true))
            .blurXY(end: 16, duration: 600.ms)
            .tint(color: const Color(0xFF80DDFF)),

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

    // example of driving animations with a ScrollController

    // create the ScrollController:
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

    // layer the indicators & rocket behind the list, and assign the
    // the animations (via ScrollAdapter), and the list:
    Widget list = Stack(
      children: [
        // background color:
        Container(color: const Color(0xFF202125)),

        // top indicator:
        Container(
          height: 64,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x4080DDFF), Color(0x0080DDFF)]),
          ),
        )
            .animate(
              adapter: ScrollAdapter(
                scrollController,
                end: 500, // end 500px into the scroll
              ),
            )
            .scaleY(alignment: Alignment.topCenter),

        // bottom indicator:
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 64,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Color(0x4080DDFF), Color(0x0080DDFF)],
              ),
            ),
          )
              .animate(
                adapter: ScrollAdapter(
                  scrollController,
                  begin: -500, // begin 500px before the end of the scroll
                ),
              )
              .scaleY(alignment: Alignment.bottomCenter, end: 0),
        ),

        // rocket:
        const Text('🚀', style: TextStyle(fontSize: 96))
            .animate(
              adapter: ScrollAdapter(
                scrollController,
                animated: true, // smooth the scroll input
              ),
            )
            .scaleXY(end: 0.5, curve: Curves.easeIn)
            .fadeOut()
            .custom(
              // custom animation to move it via Align
              begin: -1,
              builder: (_, value, child) => Align(
                alignment: Alignment(value, -value),
                child: child,
              ),
            )
            .shake(hz: 3.5, rotation: 0.15), // wobble a bit

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
