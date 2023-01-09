import 'package:flutter/widgets.dart';
import 'flutter_animate.dart';

/// The Flutter Animate library makes adding beautiful animated effects to your widgets
/// simple. It supports both a declarative and chained API. The latter is exposed
/// via the `Widget.animate` extension, which simply wraps the widget in `Animate`.
///
/// ```
/// // declarative:
/// Animate(child: foo, effects: [FadeEffect(), ScaleEffect()])
/// 
/// // chained API:
/// foo.animate().fade().scale() // equivalent to above
/// ```
///
/// Effects are always run in parallel (ie. the fade and scale effects in the
/// example above would be run simultaneously), but you can apply delays to
/// offset them or run them in sequence.
///
/// All effects classes are immutable, and can be shared between `Animate`
/// instances, which lets you create libraries of effects to reuse throughout
/// your app.
///
/// ```
/// List<Effect> transitionIn = [
///   FadeEffect(duration: 100.ms, curve: Curves.easeOut),
///   ScaleEffect(begin: 0.8, curve: Curves.easeIn)
/// ];
/// // then:
/// Animate(child: foo, effects: transitionIn)
/// // or:
/// foo.animate(effects: transitionIn)
/// ```
///
/// Effects inherit some of their properties (delay, duration, curve) from the
/// previous effect if unspecified. So in the examples above, the scale will use
/// the same duration as the fade that precedes it. All effects have
/// reasonable defaults, so they can be used simply: `foo.animate().fade()`
///
/// Note that all effects are composed together, not run sequentially. For example,
/// the following would not fade in myWidget, because the fadeOut effect would still be
/// applying an opacity of 0:
///
/// ```
/// myWidget.animate().fadeOut(duration: 200.ms).fadeIn(delay: 200.ms)
/// ```
///
/// See [SwapEffect] for one approach to work around this.

// ignore: must_be_immutable
class Animate extends StatefulWidget with AnimateManager<Animate> {
  /// Default duration for effects.
  static Duration defaultDuration = const Duration(milliseconds: 300);

  /// Default curve for effects.
  static Curve defaultCurve = Curves.linear;

  /// If true, then animations will automatically restart whenever a hot reload
  /// occurs. This is useful for testing animations quickly during development.
  /// 
  /// You can get similar results for an individual animation by passing it a
  /// [UniqueKey], which will cause it to restart each time it is rebuilt.
  /// 
  /// ```
  /// myWidget.animate(key: UniqueKey()).fade()
  /// ```
  static bool restartOnHotReload = false;

  /// Widget types to reparent, mapped to a method that handles that type. This is used
  /// to make it easy to work with widgets that require specific parents. For example,
  /// the [Positioned] widget, which needs its immediate parent to be a [Stack].
  ///
  /// Handles [Flexible], [Positioned], and [Expanded] by default, but you can add additional
  /// handlers as appropriate. Example, this would add support for a hypothetical
  /// "AlignPositioned" widget, that has an `alignment` property.
  ///
  /// ```
  /// Animate.reparentTypes[AlignPositioned] = (parent, child) {
  ///   AlignPositioned o = parent as AlignPositioned;
  ///   return AlignPositioned(alignment: o.alignment, child: child);
  /// }
  /// ```
  static Map reparentTypes = <Type, ReparentChildBuilder>{
    Flexible: (parent, child) {
      Flexible o = parent as Flexible;
      return Flexible(key: o.key, flex: o.flex, fit: o.fit, child: child);
    },
    Positioned: (parent, child) {
      Positioned o = parent as Positioned;
      return Positioned(
        key: o.key,
        left: o.left,
        top: o.top,
        right: o.right,
        bottom: o.bottom,
        width: o.width,
        height: o.height,
        child: child,
      );
    },
    Expanded: (parent, child) {
      Expanded o = parent as Expanded;
      return Expanded(key: o.key, flex: o.flex, child: child);
    }
  };

  /// Creates an Animate instance that will manage a list of effects and apply
  /// them to the specified child.
  Animate({
    Key? key,
    this.child = const SizedBox.shrink(),
    List<Effect>? effects,
    this.onComplete,
    this.onPlay,
    this.delay = Duration.zero,
    this.controller,
    this.adapter,
    this.target,
  }) : super(key: key) {
    _entries = [];
    if (effects != null) addEffects(effects);
  }

  /// The widget to apply effects to.
  final Widget child;

  /// Called when all effects complete. Provides an opportunity to
  /// manipulate the [AnimationController] (ex. to loop, reverse, etc).
  final AnimateCallback? onComplete;

  /// Called when the animation begins playing (ie. after [Animate.delay],
  /// immediately after [AnimationController.forward] is called).
  /// Provides an opportunity to manipulate the [AnimationController]
  /// (ex. to loop, reverse, stop, etc).
  ///
  /// For example, this would pause the animation at its start:
  /// ```
  /// foo.animate(
  ///   onPlay: (controller) => controller.stop()
  /// ).fadeIn()
  /// ```
  /// This would loop the animation, reversing it on each loop:
  /// ```
  /// foo.animate(
  ///   onPlay: (controller) => controller.repeat(reverse: true)
  /// ).fadeIn()
  /// ```
  final AnimateCallback? onPlay;

  /// Defines a delay before the animation is started. Unlike [Effect.delay],
  /// this is not a part of the overall animation, and only runs once if the
  /// animation is looped. [onPlay] is called after this delay.
  final Duration delay;

  /// An external [AnimationController] can optionally be specified. By default
  /// Animate creates its own controller internally.
  final AnimationController? controller;

  /// An [Adapter] can drive the animation from an external source (ex. a [ScrollController],
  /// [ValueNotifier], or arbitrary `0-1` value). For more information see [Adapter]
  /// or an adapter class ([ChangeNotifierAdapter], [ScrollAdapter], [ValueAdapter],
  /// [ValueNotifierAdapter]).
  ///
  /// If an adapter is provided, then [delay] is ignored, and you should not
  /// make changes to the [AnimationController] directly (ex. via [onPlay])
  /// because it can cause unexpected results.
  final Adapter? adapter;

  /// Sets a target position for the animation between 0 (start) and 1 (end).
  /// When [target] is changed, it will animate to the new position.
  /// 
  /// Ex. fade and scale a button when an `_over` state changes:
  /// ```
  /// MyButton().animate(target: _over ? 1 : 0)
  ///   .fade(end: 0.8).scaleXY(end: 1.1)
  /// ```
  final double? target;

  late final List<EffectEntry> _entries;
  Duration _duration = Duration.zero;
  EffectEntry? _lastEntry;

  /// The total duration for all effects.
  Duration get duration => _duration;

  @override
  State<Animate> createState() => _AnimateState();

  /// Adds an effect. This is mostly used by [Effect] extension methods to append effects
  /// to an [Animate] instance.
  @override
  Animate addEffect(Effect effect) {
    EffectEntry? prior = _lastEntry;

    Duration delay = (effect is ThenEffect)
        ? (effect.delay ?? Duration.zero) +
            (prior?.delay ?? Duration.zero) +
            (prior?.duration ?? Duration.zero)
        : effect.delay ?? prior?.delay ?? Duration.zero;

    EffectEntry entry = EffectEntry(
      effect: effect,
      delay: delay,
      duration: effect.duration ?? prior?.duration ?? Animate.defaultDuration,
      curve: effect.curve ?? prior?.curve ?? Animate.defaultCurve,
      owner: this,
    );

    _entries.add(entry);
    _lastEntry = entry;
    if (entry.end > _duration) _duration = entry.end;
    return this;
  }
}

class _AnimateState extends State<Animate> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isInternalController = false;
  bool _hasAdapter = false;
  Future<void>? _delayed;

  @override
  void initState() {
    super.initState();
    _restart();
  }

  @override
  void didUpdateWidget(Animate oldWidget) {
    if (oldWidget.controller != widget.controller ||
        oldWidget._duration != widget._duration) {
      _initController();
      _play();
    } else if (oldWidget.adapter != widget.adapter) {
      _initAdapter();
    } else if (widget.target != oldWidget.target && widget.target != null) {
      _play();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Animate.restartOnHotReload) _restart();
  }

  void _restart() {
    _delayed?.ignore();
    _initController();
    _delayed = Future.delayed(widget.delay, () => _play());
  }

  void _initController() {
    AnimationController? controller;

    if (widget.controller != null) {
      // externally provided AnimationController.
      controller = widget.controller!;
      _isInternalController = false;
    } else if (!_isInternalController) {
      // create a new internal AnimationController.
      controller = AnimationController(vsync: this);
      _isInternalController = true;
    } else {
      // pre-existing controller.
    }

    if (controller != null) {
      // new controller.
      _controller = controller;
      _controller.addStatusListener(_handleAnimationStatus);
    }

    _controller.duration = widget._duration;
    _initAdapter();
  }

  void _initAdapter() {
    final Adapter? adapter = widget.adapter;
    _hasAdapter = adapter != null;
    adapter?.init(_controller);
  }

  void _disposeController() {
    if (_isInternalController) _controller.dispose();
    _isInternalController = false;
  }

  @override
  void dispose() {
    _delayed?.ignore();
    _disposeController();
    super.dispose();
  }

  void _handleAnimationStatus(status) {
    if (status == AnimationStatus.completed) {
      widget.onComplete?.call(_controller);
    }
  }

  void _play() {
    _delayed?.ignore(); // for poorly timed hot reloads.
    double? pos = widget.target;
    if (pos != null) {
      _controller.animateTo(pos);
    } else if (!_hasAdapter) {
      _controller.forward(from: 0);
      widget.onPlay?.call(_controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child, parent = child;
    ReparentChildBuilder? reparent = Animate.reparentTypes[child.runtimeType];
    if (reparent != null) child = (child as dynamic).child;
    for (EffectEntry entry in widget._entries) {
      child = entry.effect.build(context, child, _controller, entry);
    }
    return reparent?.call(parent, child) ?? child;
  }
}

/// Wraps the target Widget in an Animate instance. Ex. `myWidget.animate()` is equivalent
/// to `Animate(child: myWidget)`.
extension AnimateWidgetExtensions on Widget {
  Animate animate({
    Key? key,
    List<Effect>? effects,
    AnimateCallback? onComplete,
    AnimateCallback? onPlay,
    Duration delay = Duration.zero,
    AnimationController? controller,
    Adapter? adapter,
    double? target,
  }) =>
      Animate(
        key: key,
        effects: effects,
        onComplete: onComplete,
        onPlay: onPlay,
        delay: delay,
        controller: controller,
        adapter: adapter,
        target: target,
        child: this,
      );
}

/// The builder type used by [Animate.reparentTypes]. It must accept an existing
/// parent widget, and rebuild it with the provided child. In effect, it clones
/// the provided parent widget with the new child.
typedef ReparentChildBuilder = Widget Function(Widget parent, Widget child);

/// Function signature for [Animate] callbacks.
typedef AnimateCallback = void Function(AnimationController controller);
