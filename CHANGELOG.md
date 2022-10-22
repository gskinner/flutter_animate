# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2022-10-23
### Added
- `FlipEffect` (2.5d card flip)
- `loop` extension to `AnimationController`
- support for non-uniform blurs in `BlurEffect`
- `animated` property for all adapters
- `transformHitTest` param on `MoveEffect`
- first set of automated tests

### Changed
- all effects now use "smart" parameters. See "Other Parameters" in the README for more info.
- changes to some effect extension methods (ex. `move`) to be more consistent
- fix for `BlurEffect` on the web with low sigma values
- exposed some effects' utility methods as static methods
- changed `SwapEffect.builder` method signature to have a non-nullable child
- minor documentation improvements and small fixes

### Removed
- `unblur` extension method. Use `blurXY` with a `begin` value instead.

## [1.0.0] - 2022-08-18
### Added
- `RotateEffect`

### Changed
- `SwapEffect.builder` now receives a reference to the original child
- `Animate.onInit` renamed to `onPlay`
- improved hot reload support

## [0.3.0] - 2022-06-20
### Added
- `.unblur()` extension method
- `.effect()` extension method
- kitchen sink example view

### Changed
- Optimized all effect builders to only build on value change
- Minor cleanup
- `ShakeEffect` now uses `hz` instead of `count`
- `TintEffect` now uses opaque black for default color
- Made `CallbackEffect` more robust

## [0.2.0] - 2022-06-17
### Added
- Adapters: Drive animations from external sources (scrolling, notifiers, etc)
- `ShakeEffect`: translation and/or rotation based shaking effect
- `SaturateEffect`: Color saturation effect (ex. animate to grayscale)
- `TintEffect`: Animated color tint

### Changed
- Fix issue with `Animate` delay returning after dispose
- Improved example

## [0.1.1] - 2022-05-31
### Changed
- Fix a major widget lifecycle issue with `Animate` delay

## [0.1.0] - 2022-05-29
### Added
- `ShimmerEffect`: can do a variety of gradient effects, including load shimmers
- `ThenEffect`: simplifies sequencing effects by calculating a new inheritable delay

### Changed
- `onInit` & `onComplete` are now propagated to all children of `AnimateList`
- improved documentation
- `Animate` delay is now separate from the animation and only runs once
- Effect is now an empty effect instead of an abstract class
- Updated example
- Fixed an issue with property inheritance through multiple effects

## [0.0.1] - 2022-05-20
### Added
- Initial pre-release