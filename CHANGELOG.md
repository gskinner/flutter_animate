# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - TBD
### Added
- `.unblur()` extension method
- `.effect()` extension method
- kitchen sink example view

### Changed
- Optimized all effect builders to only build on value change
- Minor cleanup
- `ShakeEffect` now uses `hz` instead of `count`
- `TintEffect` now uses opaque black for default color

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