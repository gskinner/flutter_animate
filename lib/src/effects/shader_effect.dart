import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';

import 'package:flutter/widgets.dart';

import '../../flutter_animate.dart';

/**
 * This is an unfinished, prerelease effect for Flutter Animate:
 * https://pub.dev/packages/flutter_animate
 * 
 * It includes a copy of `AnimatedSampler` from Flutter Shaders:
 * https://github.com/jonahwilliams/flutter_shaders
 * 
 * Once `AnimatedSampler` (or equivalent) is stable, or included in the core
 * SDK, this effect will be updated, tested, refined, and added to the 
 * effects.dart file.
 * 
 * To use this effect you must import it specifically, it is not included
 * in the default exports.
 */

/// **NOTE: This is a prerelease shader. You must import it directly to use it.**
///
/// Effect that applies an animated fragment shader to a target. See
/// [Writing and using fragment shaders](https://docs.flutter.dev/development/ui/advanced/shaders)
/// for information on how to include shaders in your app.
///
/// [shader] is the [FragmentShader] to apply to the target. If `null` no effect
/// will be applied.
///
/// [overflow] defines a buffer space around the target to draw the shader. This
/// is useful for effects that draw outside of the target bounds, such as blurs.
/// Defaults to [EdgeInsets.zero].
///
/// [layer] allows you to layer the shader above, below, or completely replace
/// the target visually. Defaults to [ShaderLayer.replace].
///
/// [update] is an optional callback that allows you to update the shader. It
/// is called whenever the animation value changes. It accepts a
/// [ShaderUpdateDetails] object. It can update uniforms directly via
/// `setFloat` or `setImageSampler`, or by using [ShaderUpdateDetails.updateUniforms].
///
/// If [update] is not specified, the shader will be updated automatically based
/// on the "standardized" uniforms defined in [ShaderUpdateDetails.updateUniforms].
///
/// The [update] callback may return an [EdgeInsets] to define the overflow, or
/// `null` to use the [overflow] value.
@immutable
class ShaderEffect extends Effect<double> {
  const ShaderEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    this.shader,
    this.overflow,
    ShaderLayer? layer,
    this.update,
  })  : layer = layer ?? ShaderLayer.replace,
        super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: 0,
          end: 1,
        );

  final ui.FragmentShader? shader;
  final EdgeInsets? overflow;
  final ShaderLayer layer;
  final ShaderUpdateCallback? update;

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    double ratio = 1 / MediaQuery.of(context).devicePixelRatio;
    Animation<double> animation = buildAnimation(controller, entry);
    return getOptimizedBuilder<double>(
      animation: animation,
      builder: (_, __) {
        return AnimatedSampler(
          (ui.Image image, Size size, Canvas canvas) {
            ShaderUpdateDetails details = ShaderUpdateDetails(
              shader: shader!,
              value: animation.value,
              size: size,
              image: image,
            );

            EdgeInsets? insets = overflow;
            if (update != null) {
              insets ??= update!(details);
            } else {
              details.updateUniforms();
            }

            Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
            rect = insets?.inflateRect(rect) ?? rect;

            drawImage() {
              canvas.save();
              canvas.scale(ratio, ratio);
              canvas.drawImage(image, Offset.zero, Paint());
              canvas.restore();
            }

            if (layer == ShaderLayer.foreground) drawImage();
            if (shader != null) canvas.drawRect(rect, Paint()..shader = shader);
            if (layer == ShaderLayer.background) drawImage();
          },
          enabled: shader != null,
          child: child,
        );
      },
    );
  }
}

extension ShaderEffectExtensions<T> on AnimateManager<T> {
  /// Adds a [shader] extension to [AnimateManager] ([Animate] and [AnimateList]).
  T shader({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    ui.FragmentShader? shader,
    EdgeInsets? overflow,
    ShaderLayer? layer,
    ShaderUpdateCallback? update,
  }) =>
      addEffect(ShaderEffect(
        delay: delay,
        duration: duration,
        curve: curve,
        shader: shader,
        overflow: overflow,
        layer: layer,
        update: update,
      ));
}

enum ShaderLayer { foreground, background, replace }

/// Passed to the [ShaderEffect.update] callback. Contains information and
/// methods necessary for updating the shader.
///
/// [shader] is the shader to update.
/// [value] is the current animation value of the effect.
/// [size] is the on-screen dimensions of the target.
/// [image] is a snapshot of the target, which can be used as an input texture.
class ShaderUpdateDetails {
  ShaderUpdateDetails({
    required this.shader,
    required this.value,
    required this.size,
    required this.image,
  });

  final ui.FragmentShader shader;
  final double value;
  final Size size;
  final ui.Image image;

  /// Updates uniforms on the shader. It assumes a standardized set of initial
  /// uniforms:
  /// - float `0`: width
  /// - float `1`: height
  /// - float `2`: value
  /// - image sampler `0`: image
  ///
  /// For example, this could be defined in the fragment shader as:
  /// ``` glsl
  /// uniform vec2 size; // float 0 and 1
  /// uniform float value; // float 2
  /// uniform sampler2D image; // image sampler 0
  /// ```
  ///
  /// You can specify [value] to override the default animation value.
  ///
  /// You can also pass additional uniforms via [floats] and [images]. These
  /// will be set in the shader in the order they are passed. For example,
  /// if you pass `floats: [intensity]`, then the intensity value will be
  /// assigned to float `3`.
  void updateUniforms({
    double? value,
    List<double>? floats,
    List<ui.Image>? images,
  }) {
    // floats:
    int i = 0;
    shader.setFloat(i, size.width);
    shader.setFloat(++i, size.height);
    shader.setFloat(++i, value ?? this.value);
    floats?.forEach((o) => shader.setFloat(++i, o));

    // images:
    i = 0;
    shader.setImageSampler(i, image);
    images?.forEach((o) => shader.setImageSampler(++i, o));
  }
}

/// Function signature for [ShaderEffect] update handlers.
typedef ShaderUpdateCallback = EdgeInsets? Function(
    ShaderUpdateDetails details);

/******************************************************************************/
// TODO: add this as a dependency instead of copying it in once it is stable:
// https://github.com/jonahwilliams/flutter_shaders

// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// A callback for the [AnimatedSamplerBuilder] widget.
typedef AnimatedSamplerBuilder = void Function(
  ui.Image image,
  Size size,
  ui.Canvas canvas,
);

/// **NOTE: This is included in [ShaderEffect] for now, but will become a dependency
/// once `flutter_shaders` is stable, or similar functionality is added to the SDK.**
///
/// A widget that allows access to a snapshot of the child widgets for painting
/// with a sampler applied to a [FragmentProgram].
///
/// When [enabled] is true, the child widgets will be painted into a texture
/// exposed as a [ui.Image]. This can then be passed to a [FragmentShader]
/// instance via [FragmentShader.setSampler].
///
/// If [enabled] is false, then the child widgets are painted as normal.
///
/// Caveats:
///   * Platform views cannot be captured in a texture. If any are present they
///     will be excluded from the texture. Texture-based platform views are OK.
///
/// Example:
///
/// Providing an image to a fragment shader using
/// [FragmentShader.setImageSampler].
///
/// ```dart
/// Widget build(BuildContext context) {
///   return AnimatedSampler(
///     (ui.Image image, Size size, Canvas canvas) {
///       shader
///         ..setFloat(0, size.width)
///         ..setFloat(1, size.height)
///         ..setImageSampler(0, image);
///       canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
///     },
///     child: widget.child,
///   );
/// }
/// ```
///
/// See also:
///   * [SnapshotWidget], which provides a similar API for the purpose of
///      caching during expensive animations.
class AnimatedSampler extends StatelessWidget {
  /// Create a new [AnimatedSampler].
  const AnimatedSampler(
    this.builder, {
    required this.child,
    super.key,
    this.enabled = true,
  });

  /// A callback used by this widget to provide the children captured in
  /// a texture.
  final AnimatedSamplerBuilder builder;

  /// Whether the children should be captured in a texture or displayed as
  /// normal.
  final bool enabled;

  /// The child widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _ShaderSamplerBuilder(
      builder,
      enabled: enabled,
      child: child,
    );
  }
}

class _ShaderSamplerBuilder extends SingleChildRenderObjectWidget {
  const _ShaderSamplerBuilder(
    this.builder, {
    super.child,
    required this.enabled,
  });

  final AnimatedSamplerBuilder builder;
  final bool enabled;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderShaderSamplerBuilderWidget(
      devicePixelRatio: MediaQuery.of(context).devicePixelRatio,
      builder: builder,
      enabled: enabled,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    (renderObject as _RenderShaderSamplerBuilderWidget)
      ..devicePixelRatio = MediaQuery.of(context).devicePixelRatio
      ..builder = builder
      ..enabled = enabled;
  }
}

// A render object that conditionally converts its child into a [ui.Image]
// and then paints it in place of the child.
class _RenderShaderSamplerBuilderWidget extends RenderProxyBox {
  // Create a new [_RenderSnapshotWidget].
  _RenderShaderSamplerBuilderWidget({
    required double devicePixelRatio,
    required AnimatedSamplerBuilder builder,
    required bool enabled,
  })  : _devicePixelRatio = devicePixelRatio,
        _builder = builder,
        _enabled = enabled;

  @override
  OffsetLayer updateCompositedLayer(
      {required covariant _ShaderSamplerBuilderLayer? oldLayer}) {
    final _ShaderSamplerBuilderLayer layer =
        oldLayer ?? _ShaderSamplerBuilderLayer(builder);
    layer
      ..callback = builder
      ..size = size
      ..devicePixelRatio = devicePixelRatio;
    return layer;
  }

  /// The device pixel ratio used to create the child image.
  double get devicePixelRatio => _devicePixelRatio;
  double _devicePixelRatio;
  set devicePixelRatio(double value) {
    if (value == devicePixelRatio) {
      return;
    }
    _devicePixelRatio = value;
    markNeedsCompositedLayerUpdate();
  }

  /// The painter used to paint the child snapshot or child widgets.
  AnimatedSamplerBuilder get builder => _builder;
  AnimatedSamplerBuilder _builder;
  set builder(AnimatedSamplerBuilder value) {
    if (value == builder) {
      return;
    }
    _builder = value;
    markNeedsCompositedLayerUpdate();
  }

  bool get enabled => _enabled;
  bool _enabled;
  set enabled(bool value) {
    if (value == enabled) {
      return;
    }
    _enabled = value;
    markNeedsPaint();
    markNeedsCompositingBitsUpdate();
  }

  @override
  bool get isRepaintBoundary => alwaysNeedsCompositing;

  @override
  bool get alwaysNeedsCompositing => enabled;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (size.isEmpty) {
      return;
    }
    assert(!_enabled || offset == Offset.zero);
    return super.paint(context, offset);
  }
}

/// A [Layer] that uses an [AnimatedSamplerBuilder] to create a [ui.Picture]
/// every time it is added to a scene.
class _ShaderSamplerBuilderLayer extends OffsetLayer {
  _ShaderSamplerBuilderLayer(this._callback);

  Size get size => _size;
  Size _size = Size.zero;
  set size(Size value) {
    if (value == size) {
      return;
    }
    _size = value;
    markNeedsAddToScene();
  }

  double get devicePixelRatio => _devicePixelRatio;
  double _devicePixelRatio = 1.0;
  set devicePixelRatio(double value) {
    if (value == devicePixelRatio) {
      return;
    }
    _devicePixelRatio = value;
    markNeedsAddToScene();
  }

  AnimatedSamplerBuilder get callback => _callback;
  AnimatedSamplerBuilder _callback;
  set callback(AnimatedSamplerBuilder value) {
    if (value == callback) {
      return;
    }
    _callback = value;
    markNeedsAddToScene();
  }

  ui.Image _buildChildScene(Rect bounds, double pixelRatio) {
    final ui.SceneBuilder builder = ui.SceneBuilder();
    final Matrix4 transform =
        Matrix4.diagonal3Values(pixelRatio, pixelRatio, 1);
    builder.pushTransform(transform.storage);
    addChildrenToScene(builder);
    builder.pop();
    return builder.build().toImageSync(
          (pixelRatio * bounds.width).ceil(),
          (pixelRatio * bounds.height).ceil(),
        );
  }

  @override
  void addToScene(ui.SceneBuilder builder) {
    if (size.isEmpty) return;
    final ui.Image image = _buildChildScene(
      offset & size,
      devicePixelRatio,
    );
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    try {
      callback(image, size, canvas);
    } finally {
      image.dispose();
    }
    final ui.Picture picture = pictureRecorder.endRecording();
    builder.addPicture(offset, picture);
  }
}
