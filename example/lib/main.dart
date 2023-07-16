import 'package:color_hash/color_hash.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

void main() {
  // just call the clas with a string input and it will
  // produce a color

  final hashed = ColorHash(
    "Some string", // initial hash (user id or something)
    lightness: 0.5, // lightness of the color
    saturation: 0.5, // saturation of the color
    hue: (0, 360), // hue range
  );

  hashed.toColor(); // Color(0xff4055bf)

  runApp(const App());
}

// this here is the demo website where you can
// generate your own properties and see the result

class MaxWidth extends StatelessWidget {
  const MaxWidth({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 512,
        ),
        child: child,
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final TextEditingController _controller = TextEditingController(text: "Seed");

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hash = _controller.text;
      });
    });
  }

  String _hash = "Seed";
  (double, double) _hue = (0, 360);
  double _saturation = 0.5;
  double _lightness = 0.6;
  bool? _dark;

  @override
  Widget build(BuildContext context) {
    const spacing = SliverPadding(padding: EdgeInsets.all(20));
    final hashed = ColorHash(
      _hash,
      lightness: _lightness,
      saturation: _saturation,
      hue: _hue,
    );
    final hsv = HSVColor.fromColor(hashed.toColor());
    final currentBrightness = _dark == null
        ? MediaQuery.of(context).platformBrightness
        : _dark!
            ? Brightness.dark
            : Brightness.light;
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: hashed.toColor(),
          brightness: currentBrightness,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text(
                'Color Hash',
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _dark = !(currentBrightness == Brightness.dark);
                    });
                  },
                  icon: Icon(
                    currentBrightness == Brightness.dark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                )
              ],
            ),
            SliverToBoxAdapter(
              child: MaxWidth(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Seed string',
                    ),
                  ),
                ),
              ),
            ),
            spacing,
            SliverToBoxAdapter(
              child: MaxWidth(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Hue range: ${_hue.$1.toInt()} - ${_hue.$2.toInt()}",
                      ),
                    ),
                    RangeSlider(
                      min: 0,
                      max: 360,
                      values: RangeValues(_hue.$1, _hue.$2),
                      onChanged: (value) {
                        setState(() {
                          _hue = (value.start, value.end);
                        });
                      },
                    ),
                    SizedBox(
                      height: 24,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: 24,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(
                              colors: List.generate(
                                360 ~/ 10,
                                (index) {
                                  final hue = index * 10;
                                  return HSVColor.fromAHSV(
                                    1,
                                    hue.toDouble(),
                                    _saturation,
                                    _lightness,
                                  ).toColor();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            spacing,
            SliverToBoxAdapter(
              child: MaxWidth(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Saturation: ${_saturation.toStringAsFixed(2)}",
                      ),
                    ),
                    Slider(
                      min: 0.1,
                      max: 1,
                      value: _saturation,
                      onChanged: (value) {
                        setState(() {
                          _saturation = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 24,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: 24,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(
                              colors: List.generate(
                                360 ~/ 10,
                                (index) {
                                  return HSVColor.fromAHSV(
                                    1,
                                    hsv.hue,
                                    _saturation - 0.001,
                                    _lightness - 0.001,
                                  ).toColor();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            spacing,
            SliverToBoxAdapter(
              child: MaxWidth(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Lightness: ${_lightness.toStringAsFixed(2)}",
                      ),
                    ),
                    Slider(
                      min: 0.1,
                      max: 0.9,
                      value: _lightness,
                      onChanged: (value) {
                        setState(() {
                          _lightness = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 24,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        height: 24,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.black,
                                Colors.white,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: MaxWidth(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Text(
                      "Color: ${hashed.toHexString()}",
                      style: TextStyle(
                        color: hashed.toColor(),
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      height: 256,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          color: hashed.toColor(),
                          boxShadow: [
                            BoxShadow(
                              color: hashed.toColor().withOpacity(1),
                              blurRadius: 64,
                              spreadRadius: -24,
                              offset: const Offset(0, 24),
                            )
                          ]),
                    )
                  ]),
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: Container(
          height: 64,
          color: hashed.toColor(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Copyright © ${DateTime.now().year} - Alek Angelov",
                  style: TextStyle(
                    color: hashed.toColor().computeLuminance() > 0.5
                        ? Colors.black
                        : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Link(
                  uri: Uri.parse("https://alekangelov.com"),
                  builder: (c, f) => TextButton(
                    onPressed: f,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      "https://alekangelov.com",
                      style: TextStyle(
                        color: hashed.toColor().computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
