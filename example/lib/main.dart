import 'package:flutter/material.dart';

import 'examples/adapter_view.dart';
import 'examples/info_view.dart';
import 'examples/visual_view.dart';

// TODO: Add additional examples, especially a proper UI example.
// TODO: and a builder example. Maybe a countdown of some kind? Thermometer with counter?

void main() {
  runApp(const MyApp());
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
        'Visual Effects', 'Visual effects like saturation, tint, & blur.'),
    //TabInfo(Icons.auto_awesome_mosaic_outlined, (_) => InfoView(), 'UI',
    //    'User interface example. Shimmer, fade, slide.'), // TODO.
    TabInfo(Icons.format_list_bulleted, (_) => const AdapterView(), 'Adapters',
        'Using adapters to drive animations from scrolling or user input.'),
    //TabInfo(Icons.auto_awesome_outlined, (_) => InfoView(), 'Fun',
    //    'Fun silliness.'), // TODO.
  ];

  @override
  State<FlutterAnimateExample> createState() => _FlutterAnimateExampleState();
}

class _FlutterAnimateExampleState extends State<FlutterAnimateExample> {
  int _viewIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> barItems = [];
    for (int i = 0; i < FlutterAnimateExample.tabs.length; i++) {
      final TabInfo info = FlutterAnimateExample.tabs[i];
      barItems.add(
        BottomNavigationBarItem(
          icon: Icon(info.icon),
          label: info.label,
        ),
      );
    }

    Widget content = FlutterAnimateExample.tabs[_viewIndex].builder(context);

    return Scaffold(
      backgroundColor: const Color(0xFF222326),
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
        items: barItems,
      ),
      body: DefaultTextStyle(
        style: const TextStyle(
          color: Color(0xFFCCCDCF),
          fontSize: 14,
          height: 1.5,
        ),
        child: content,
      ),
    );
  }
}

class TabInfo {
  TabInfo(this.icon, this.builder, this.label, this.description);

  final IconData icon;
  final WidgetBuilder builder;
  final String label;
  final String description;
}
