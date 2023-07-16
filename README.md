# Color Hash

## A utility for generating persistent colors based on a string for flutter.

![logo](https://github.com/alekangelov/color_hash/raw/main/logo.jpg)

### Motivation

I needed a way to generate a color based on a string that would be consistent and persistent. Flutter has it's own comparison method so I opted to use that. There are all the features you would want from a color generator, including the ability to generate create a factory with your own options.

### Usage

You can create a factory or use it with the defualt options

```dart
import 'package:color_hash/color_hash.dart';

void defaultOptions() {
  ColorHash colorHash = ColorHash("input");
  Color color = colorHash.toColor();
  print(color); // Color(0xFFSomeColor)
}

void hasherFactory() {
  final hasher = ColorHash.createHasher(
    saturation: 0.5,
    lightness: 0.5,
    hue: (0, 360),
  );

  final hashed = hasher("input");
  print(hashed.toColor()); // Color(0xFFSomeColor)
}

```

### Tooling

I also made this app that lets you dial in the settigns and see the output:
![screenshot of tool](https://github.com/alekangelov/color_hash/raw/main/screenshot.jpg)
https://alekangelov.github.io/color_hash/

### Options

| key        | type             | description                                                                                      |
| ---------- | ---------------- | ------------------------------------------------------------------------------------------------ |
| 0          | String           | The original input is a positional argument and is used to create the color for the whole thing. |
| saturation | double           | How saturated should the output color be.                                                        |
| lightness  | double           | How dark/light should the output color be.                                                       |
| hue        | (double, double) | What hue range should the output color be (between 0 and 360, otherwise it will throw).          |

### Author

Alek Angelov - [GitHub](https://github.com/alekangelov) - [LinkedIn](https://www.linkedin.com/in/alekangelov/) - [Website](https://alekangelov.com)

### Licence - MIT

Copyright 2023 Alek Angelov

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
