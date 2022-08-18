// Kitchen sink view of all Effects

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EverythingView extends StatelessWidget {
  const EverythingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, box) => GridView.count(
        crossAxisCount: (box.maxWidth / 128).floor(),
        childAspectRatio: 0.8,
        children: [
          // these are in alphabetic order according to their classes
          // ex. BlurEffect defines both blur and unblur.

          tile("blur", a.blur()),
          tile("unblur", a.unblur()),

          // callback?

          tile("custom", a.custom(builder: (_, val, child) {
            val = val * pi * 2 - pi / 2;
            return Transform.translate(
              offset: Offset(cos(val) * 24, sin(val) * 24),
              child: Transform.scale(scale: 0.66, child: child),
            );
          })),

          tile("fadeIn", a.fadeIn()),
          tile("fadeOut", a.fadeOut()),

          // listen?

          tile("move", a.move()),

          tile("rotate", a.rotate()),

          tile("saturate", a.saturate()),
          tile("desaturate", a.desaturate()),

          tile("scale", a.scale()),

          tile("shake", a.shake()),
          tile("shakeX", a.shakeX()),
          tile("shakeY", a.shakeY()),

          tile("shimmer", a.shimmer()),

          tile("slide", a.slide()),

          tile("swap", a.swap(builder: (_, __) => const Text("HELLO!"))),
          tile("swap (child)", a.swap(builder: (_, child) {
            return Opacity(opacity: 0.5, child: child!);
          })),

          // then?

          tile("tint", a.tint()),
          tile("untint", a.untint()),

          tile("toggle", a.toggle(builder: (_, b, child) {
            return Container(
              color: b ? Colors.purple : Colors.yellow,
              padding: const EdgeInsets.all(8),
              child: child,
            );
          })),

          tile("hide", a.hide()),
          tile("show", a.show()),
        ],
      ),
    );
  }

  // this returns a ready to use Animate instance targeting a `box` (see below)
  // it uses empty effects to set default delay/duration values (750 & 1500ms)
  // and a total duration (3000ms), so there is a 750ms pause at the end.
  Animate get a => box
      .animate(onPlay: (controller) => controller.repeat())
      .effect(duration: 3000.ms) // this "pads out" the total duration
      .effect(delay: 750.ms, duration: 1500.ms); // set defaults

  // simple square box with a gradient to use as the target for animations.
  Widget get box => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.green, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        width: 64,
        height: 64,
      );

  // grid tile. Naming should be `buildTile`, but going for brevity.
  Widget tile(String label, Widget demo) => Container(
        margin: const EdgeInsets.all(4),
        color: Colors.black12,
        height: 160,
        child: Column(
          children: [
            Flexible(child: Center(child: demo)),
            Container(
              color: Colors.black12,
              height: 32,
              alignment: Alignment.center,
              child: Text(label, style: const TextStyle(fontSize: 12)),
            )
          ],
        ),
      );
}
