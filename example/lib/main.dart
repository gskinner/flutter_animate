import 'dart:ui';

import 'package:example/examples/everything_view.dart';
import 'package:flutter/material.dart';

import 'examples/adapter_view.dart';
import 'examples/info_view.dart';
import 'examples/playground_view.dart';
import 'examples/visual_view.dart';

void main() {
  runApp(const MyApp());
  _loadShader(); // this is a touch hacky, but works for now.
}

Future<void> _loadShader() async {
  return FragmentProgram.fromAsset('assets/shaders/shader.frag').then(
      (FragmentProgram prgm) {
    EverythingView.shader = prgm.fragmentShader();
  }, onError: (Object error, StackTrace stackTrace) {
    FlutterError.reportError(
        FlutterErrorDetails(exception: error, stack: stackTrace));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Animate Demo',
      debugShowCheckedModeBanner: false,
      home: FlutterAnimateExample(),
    );
  }
}

// this is a very quick and dirty example.
class FlutterAnimateExample extends StatefulWidget {
  const FlutterAnimateExample({Key? key}) : super(key: key);

  static final List<TabInfo> tabs = [
    TabInfo(Icons.info_outline, (_) => InfoView(key: UniqueKey()), 'Info',
        'Simple example of Widget & List animations.'),
    TabInfo(Icons.palette_outlined, (_) => VisualView(key: UniqueKey()),
        'Visual', 'Visual effects like saturation, tint, & blur.'),
    TabInfo(Icons.format_list_bulleted, (_) => const AdapterView(), 'Adapters',
        'Animations driven by scrolling & user input.'),
    TabInfo(Icons.grid_on_outlined, (_) => const EverythingView(),
        'Kitchen Sink', 'Grid view of effects with default settings.'),
    TabInfo(Icons.science_outlined, (_) => TestView(key: UniqueKey()),
        'Sandbox', 'A blank canvas for experimenting.'),
  ];

  @override
  State<FlutterAnimateExample> createState() => _FlutterAnimateExampleState();
}

class _FlutterAnimateExampleState extends State<FlutterAnimateExample> {
  int _viewIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF404349),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _viewIndex,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedItemColor: const Color(0xFF80DDFF),
        unselectedItemColor: const Color(0x998898A0),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2A2B2F),
        elevation: 0,
        onTap: (index) => setState(() => _viewIndex = index),
        items: [
          for (final tab in FlutterAnimateExample.tabs)
            BottomNavigationBarItem(
              icon: Icon(tab.icon),
              label: tab.label,
            )
        ],
      ),
      body: DefaultTextStyle(
        style: const TextStyle(
          color: Color(0xFFCCCDCF),
          fontSize: 14,
          height: 1.5,
        ),
        child: SafeArea(
          bottom: false,
          child: FlutterAnimateExample.tabs[_viewIndex].builder(context),
        ),
      ),
    );
  }
}

class TabInfo {
  const TabInfo(this.icon, this.builder, this.label, this.description);

  final IconData icon;
  final WidgetBuilder builder;
  final String label;
  final String description;
}
