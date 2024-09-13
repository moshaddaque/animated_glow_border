<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# AnimatedGlowBorder

`AnimatedGlowBorder` is a customizable widget that provides an animated gradient border with a glowing effect.

## Features

- **borderWidth**: The width of the animated gradient border.
- **borderRadius**: The radius of the border, allowing for rounded corners.
- **blurRadius**: The blur radius for the glow effect around the border.
- **glowOpacity**: The opacity level of the glow effect.
- **spreadRadius**: The spread radius of the glow around the border.
- **animationDuration**: The duration of the gradient animation.
- **startColor**: The starting color of the gradient.
- **endColor**: The ending color of the gradient.

## Example Usage

```dart
import 'package:animated_glow_border/animated_glow_border.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedGlowBorder(
      borderWidth: 4.0,
      borderRadius: 12.0,
      blurRadius: 10.0,
      glowOpacity: 0.8,
      spreadRadius: 5.0,
      animationDuration: Duration(seconds: 2),
      startColor: Colors.blue,
      endColor: Colors.purple,
      child: Container(
        width: 200,
        height: 200,
        alignment: Alignment.center,
        child: Text(
          'Glow Border!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
