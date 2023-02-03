// Kitchen sink view of all Effects
// Note the use of shortcut methods (defined at the bottom) to make these more concise

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EverythingView extends StatelessWidget {
  const EverythingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => GridView.count(
        crossAxisCount: (constraints.maxWidth / 192).floor(),
        childAspectRatio: 0.85,
        children: [
          /***
          A few fun / interesting examples
          ***/
          tile(
            'fade+tint+blur+scale',
            a
                .fadeIn(curve: Curves.easeOutCirc)
                .untint(color: Colors.white)
                .blurXY(begin: 16)
                .scaleXY(begin: 1.5),
          ),
          tile(
            'fade+blur+move',
            a
                .fadeIn(curve: Curves.easeOutExpo)
                .blurY(begin: 32)
                .slideY(begin: -0.4, end: 0.4),
          ),
          tile(
            'scale',
            a.scale(begin: const Offset(2, 0), curve: Curves.elasticOut),
          ),
          tile(
            'scale+move+elevation',
            a
                .scaleXY(end: 1.15, curve: Curves.easeOutBack)
                .moveY(end: -10)
                .elevation(end: 24),
          ),
          tile(
            'shimmer+rotate',
            a
                .shimmer(
                  blendMode: BlendMode.dstIn,
                  angle: pi / 4,
                  size: 3,
                  curve: Curves.easeInOutCirc,
                )
                .rotate(begin: -pi / 12),
          ),
          tile(
            'shimmer+elevation+flip',
            a
                .shimmer(angle: -pi / 2, size: 3, curve: Curves.easeOutCubic)
                .elevation(begin: 24, end: 2)
                .flip(),
          ),
          tile(
            'shake+scale+tint',
            a
                .shake(curve: Curves.easeInOutCubic, hz: 3)
                .scaleXY(begin: 0.8)
                .tint(color: Colors.red, end: 0.6),
          ),
          tile(
            'shake+slide+slide',
            a
                .shake(curve: Curves.easeInOut, hz: 0.5)
                .slideX(curve: Curves.easeOut, begin: -0.4, end: 0.4)
                .slideY(curve: Curves.bounceOut, begin: -0.4, end: 0.4),
          ),
          tile(
            'boxShadow+scale',
            a
                .boxShadow(
                  end: const BoxShadow(
                    blurRadius: 4,
                    color: Colors.white,
                    spreadRadius: 3,
                  ),
                  curve: Curves.easeOutExpo,
                )
                .scaleXY(end: 1.1, curve: Curves.easeOutCirc),
          ),
          tile(
            'slide+flip+scale+tint',
            a
                .slideX(begin: 1)
                .flipH(begin: -1, alignment: Alignment.centerRight)
                .scaleXY(begin: 0.75, curve: Curves.easeInOutQuad)
                .untint(begin: 0.6),
          ),

          /***
          Catalog of minimal examples for all visual effects.
          In alphabetic order of the effect's class name.
          ***/

          //tile('blur', a.blur()),
          tile('blurX', a.blurX()),
          tile('blurY', a.blurY()),
          tile('blurXY', a.blurXY()),

          tile('boxShadow', a.boxShadow()),

          tile('color', a.color()),

          tile('crossfade', a.crossfade(builder: (_) {
            return Container(
              width: _boxSize,
              height: _boxSize,
              color: const Color(0xFFDDAA00),
              alignment: Alignment.center,
              child: const Text('😎', style: TextStyle(fontSize: 60)),
            );
          })),

          // callback

          tile('custom', a.custom(builder: (_, val, child) {
            val = val * pi * 2 - pi / 2;
            return Transform.translate(
              offset: Offset(cos(val) * 24, sin(val) * 24),
              child: Transform.scale(scale: 0.66, child: child),
            );
          })),

          // effect

          tile('elevation', a.elevation()),

          //tile('fade', a.fade()),
          tile('fadeIn', a.fadeIn()),
          tile('fadeOut', a.fadeOut()),

          tile('flipH', a.flipH()),
          tile('flipV', a.flipV()),

          // listen

          //tile('move', a.move()),
          tile('moveX', a.moveX()),
          tile('moveY', a.moveY()),

          tile('rotate', a.rotate()),

          tile('saturate', a.saturate()),
          tile('desaturate', a.desaturate()),

          //tile('scale', a.scale()),
          tile('scaleX', a.scaleX()),
          tile('scaleY', a.scaleY()),
          tile('scaleXY', a.scaleXY()),

          tile('shake', a.shake()),
          tile('shakeX', a.shakeX()),
          tile('shakeY', a.shakeY()),

          tile('shimmer', a.shimmer()),

          //tile('slide', a.slide()),
          tile('slideX', a.slideX()),
          tile('slideY', a.slideY()),

          tile('swap', a.swap(builder: (_, __) => const Text('HELLO!'))),
          tile('swap (child)', a.swap(builder: (_, child) {
            return Opacity(opacity: 0.5, child: child!);
          })),

          // then

          tile('tint', a.tint()),
          tile('untint', a.untint()),

          tile('toggle', a.toggle(builder: (_, b, child) {
            return Container(
              color: b ? Colors.purple : Colors.yellow,
              padding: const EdgeInsets.all(8),
              child: child,
            );
          })),

          //tile('visibility', a.visibility()),
          tile('hide', a.hide()),
          tile('show', a.show()),
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
        width: _boxSize,
        height: _boxSize,
      );

  // grid tile. Naming should be `buildTile`, but going for brevity.
  Widget tile(String label, Widget demo) => Container(
        margin: const EdgeInsets.all(4),
        color: Colors.black12,
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

double _boxSize = 96;
