import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../main.dart';

class InfoView extends StatelessWidget {
  const InfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget title = const Text(
      'Flutter Animate Examples',
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 40,
        color: Color(0xFF666870),
        height: 1,
        letterSpacing: -1,
      ),
    );

    // here's an interesting little trick, we can nest Animate to have
    // effects that repeat and ones that only run once on the same item:
    title = title
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1200.ms, color: const Color(0xFF80DDFF))
        .animate() // this wraps the previous Animate in another Animate
        .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
        .slide();

    List<Widget> tabInfoItems = [];
    for (int i = 0; i < FlutterAnimateExample.tabs.length; i++) {
      TabInfo o = FlutterAnimateExample.tabs[i];
      tabInfoItems.add(Container(
        padding: const EdgeInsets.all(8),
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(o.icon, color: const Color(0xFF80DDFF)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                o.description,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ));
    }

    // Animate all of the info items in the list:
    tabInfoItems = tabInfoItems
        .animate(interval: 600.ms)
        .fadeIn(duration: 900.ms, delay: 300.ms)
        .shimmer(blendMode: BlendMode.srcOver, color: Colors.white12)
        .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        title,
        hr,
        const Text('''
This simple app demonstrates a few features of the flutter_animate library. More examples coming as time permits.

Switch between examples via the bottom nav bar. Tap again to restart that animation.'''),
        hr,
        ...tabInfoItems,
        hr,
        const Text(
            'These examples are over the top for demo purposes. Use restraint. :)'),
      ],
    );
  }

  Widget get hr => Container(
        height: 2,
        color: const Color(0x8080DDFF),
        margin: const EdgeInsets.symmetric(vertical: 16),
      ).animate().scale(duration: 600.ms, alignment: Alignment.centerLeft);
}
