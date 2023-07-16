import 'dart:ui';

import 'package:color_hash/color_hash.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const baseString = "Some string";
  test('same string hashes should yield same colors', () {
    final hashed = ColorHash(baseString);
    final secondHashed = ColorHash("Some string");
    final thirdHashed = ColorHash("Some other string");
    expect(hashed.toColor(), secondHashed.toColor());
    expect(hashed.toColor(), isNot(thirdHashed.toColor()));
  });

  test('should give a hex string if needed', () {
    final hashed = ColorHash(baseString);
    expect(hashed.toHexString(), "#4055BF");
  });

  test('create hasher should work properly', () {
    final hasher = ColorHash.createHasher(
      lightness: 0.9,
      saturation: 0.25,
      hue: (20, 30),
    );

    expect(hasher(baseString), const Color(0xffece3df));
  });

  test('should throw if invalid values are given', () {
    expect(
      () => ColorHash(baseString,
          hue: (555, 555), saturation: 1.1, lightness: -0.1),
      throwsAssertionError,
    );
    expect(
        () => ColorHash.createHasher(
              lightness: 2,
              saturation: 3,
              hue: (20, 578),
            ),
        throwsArgumentError);
  });
}
