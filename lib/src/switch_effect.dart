import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A widget for implementing switch effects. When calling the first time the given [child] will be animated with [inEffects].
/// When the widget is called again with a different child the [outEffects] of the previous widget instance will be applied to
/// the [child] handled by the previous widget immediately following with the animation of the new child by using the
/// [inEffects] of the new widget. Before switching the childs the optional callback method is triggered.
class SwitchEffect extends StatefulWidget {
  /// the child for this animation
  final Widget child;

  /// a list of effects to apply to the child when the child will be shown. Default is fadeIn()
  final List<Effect>? inEffects;

  /// a list of effects to apply to the child when the child should be replaced by another child. Default is fadeOut()
  final List<Effect>? outEffects;

  /// Callback function which will be triggered right after the outEffects are completed and before the new child will be swapped in for the inEffects
  final void Function(BuildContext)? onSwap;

  /// Callbak function which will be triggered after all effects are completed
  final void Function(BuildContext)? onComplete;

  const SwitchEffect(
      {super.key,
      required this.child,
      this.inEffects,
      this.outEffects,
      this.onSwap,
      this.onComplete});

  @override
  State<StatefulWidget> createState() {
    return _SwitchEffectState();
  }
}

////////////////////////////////////////////////////////////////////////////////

class _SwitchEffectState extends State {
  @override
  SwitchEffect get widget => super.widget as SwitchEffect;

  /// when changing the child of the widget this field will be filled with the child of the previous widget.
  Widget? _lastChild;

  List<Effect>? _lastOutEffects;

  @override
  Widget build(BuildContext context) {
    if (_lastChild != null) {
      return Animate(
        key: GlobalKey(),
        effects: _lastOutEffects ?? EffectList().fadeOut(),
        onComplete: (_) {
          if (widget.onSwap != null) widget.onSwap!(context);
        },
        child: _lastChild!,
      ).then().swap(
          duration: 0.seconds,
          delay: 0.seconds,
          builder: (BuildContext context, _) => Animate(
                effects: widget.inEffects ?? EffectList().fadeIn(),
                onComplete: (_) {
                  if (widget.onComplete != null) widget.onComplete!(context);
                },
                child: widget.child,
              ));
    }

    return Animate(
      key: GlobalKey(),
      effects: widget.inEffects ?? EffectList().fadeIn(),
      onComplete: (_) {
        if (widget.onComplete != null) widget.onComplete!(context);
      },
      child: widget.child,
    );
  }

  @override
  void didUpdateWidget(covariant SwitchEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _lastChild = oldWidget.child;
      _lastOutEffects = oldWidget.outEffects;
    }
  }
}
