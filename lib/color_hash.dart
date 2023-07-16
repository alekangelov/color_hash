// string to sha256 to color
import 'dart:ui';

_hueToRgb(
  double p,
  double q,
  double t,
) {
  if (t < 0) {
    t += 1;
  }
  if (t > 1) {
    t -= 1;
  }
  if (t < 1 / 6) {
    return p + (q - p) * 6 * t;
  }
  if (t < 1 / 2) {
    return q;
  }
  if (t < 2 / 3) {
    return p + (q - p) * (2 / 3 - t) * 6;
  }
  return p;
}

// hsl to rgb

_hslToRgb(
  double h,
  double s,
  double l,
) {
  double r, g, b;

  // there's no saturation, it's an achromatic color
  if (s == 0) {
    r = g = b = l;
    return (r, g, b);
  }

  final q = l < 0.5 ? l * (1 + s) : l + s - l * s;
  final p = 2 * l - q;
  r = _hueToRgb(p, q, h + 1 / 3);
  g = _hueToRgb(p, q, h);
  b = _hueToRgb(p, q, h - 1 / 3);

  return (r, g, b);
}

/// A tuple of two numbers.
typedef MinMax = (double, double);

/// A function that takes a string and returns a [Color].
///
/// This is used to create a [ColorHash] with custom settings.
///
/// See [ColorHash.createHasher].
typedef Hasher = Color Function(String);

class ColorHash {
  /// Creates a [ColorHash] from a string.
  ///
  /// [lightness] and [saturation] are used to control the saturation and lightness of the generated color.
  ///
  /// [hue] is used to control the hue of the generated color.
  ///
  /// [hue] must be a tuple of two numbers between 0 and 360.
  ///
  /// throws [AssertionError] if any of the values are invalid.
  ///
  /// throws [AssertionError] if [hue] is not a tuple of two numbers.
  ///
  /// throws [AssertionError] if [hue] values are not between 0 and 360.
  ///
  /// throws [AssertionError] if [lightness] or [saturation] are not between 0 and 1.
  ///
  /// ```dart
  /// final colorHash = ColorHash("Some string");
  /// Color c = colorHash.toColor()
  /// ```
  ColorHash(
    this.str, {
    this.lightness = 0.5,
    this.saturation = 0.5,
    this.hue = (0, 360),
  })  : assert(lightness >= 0 && lightness <= 1),
        assert(saturation >= 0 && saturation <= 1),
        assert(hue.$1 >= 0 && hue.$1 <= 360),
        assert(hue.$2 >= 0 && hue.$2 <= 360),
        assert(hue.$1 < hue.$2);

  final String str;
  final double lightness;
  final double saturation;
  final MinMax hue;
  late final Color color = toColor();

  /// Returns a [Color] from the string.
  ///
  /// returns a [Color] from the string.
  ///
  /// ```dart
  /// final colorHash = ColorHash("Some string");
  /// Color c = colorHash.toColor()
  /// ```
  Color toColor() {
    var H = str.hashCode;
    var S = saturation;
    var L = lightness;
    final (min, max) = hue;
    var h = min + (H % (max - min));
    var (r, g, b) = _hslToRgb(h / 360, S, L);
    r = (r * 255).round();
    g = (g * 255).round();
    b = (b * 255).round();
    final c = Color.fromRGBO(r, g, b, 1);
    return c;
  }

  @override
  String toString() {
    return 'ColorHash{color: $color}';
  }

  String toHexString() {
    final red = color.red.toRadixString(16).toUpperCase();
    final green = color.green.toRadixString(16).toUpperCase();
    final blue = color.blue.toRadixString(16).toUpperCase();
    final alpha = color.alpha.toRadixString(16).toUpperCase();
    return '#$red$green$blue${alpha == "FF" ? "" : alpha}';
  }

  /// Creates a [Hasher] with custom settings.
  ///
  /// [lightness] and [saturation] are used to control the saturation and lightness of the generated color.
  ///
  /// [hue] is used to control the hue of the generated color.
  ///
  /// [hue] must be a tuple of two numbers between 0 and 360.
  ///
  /// throws [ArgumentError] if any of the values are invalid.
  ///
  /// throws [ArgumentError] if [hue] is not a tuple of two numbers.
  ///
  /// throws [ArgumentError] if [hue] values are not between 0 and 360.
  ///
  /// throws [ArgumentError] if [lightness] or [saturation] are not between 0 and 1.
  ///
  /// returns a [Hasher] function that takes a string and returns a [Color].
  ///
  /// ```dart
  /// final hasher = ColorHash.createHasher(
  ///     lightness: 0.9,
  ///     saturation: 0.25,
  ///     hue: (20, 30),
  /// );
  /// final color = hasher("Some string");
  /// ```
  static Hasher createHasher({
    double lightness = 0.5,
    double saturation = 0.5,
    MinMax hue = (0, 360),
  }) {
    if (lightness < 0 || lightness > 1) {
      throw ArgumentError.value(
        lightness,
        'lightness',
        'lightness must be between 0 and 1',
      );
    }
    if (saturation < 0 || saturation > 1) {
      throw ArgumentError.value(
        saturation,
        'saturation',
        'saturation must be between 0 and 1',
      );
    }
    if (hue.$1 < 0 || hue.$1 > 360 || hue.$2 < 0 || hue.$2 > 360) {
      throw ArgumentError.value(
        hue,
        'hue',
        'hue values must be between 0 and 360',
      );
    }
    return (String str) => ColorHash(
          str,
          lightness: lightness,
          saturation: saturation,
          hue: hue,
        ).toColor();
  }
}
