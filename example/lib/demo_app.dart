import 'package:flutter/material.dart';
import 'package:inspire_blur_example/backdrop_blur_demo.dart';
import 'package:inspire_blur_example/child_blur_demo.dart';

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inspire Blur Demo',
      debugShowCheckedModeBanner: false,
      home: _DemoScreen(),
    );
  }
}

class _DemoScreen extends StatefulWidget {
  @override
  State<_DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<_DemoScreen> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: _currentPage,
        onDestinationSelected: (index) => setState(() => _currentPage = index),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.layers_rounded),
            label: 'Backdrop blur',
          ),
          const NavigationDestination(
            icon: Icon(Icons.widgets_rounded),
            label: 'Child blur',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentPage,
        children: [
          const BackdropBlurDemo(key: PageStorageKey('showcase_backdrop')),
          const ChildBlurDemo(key: PageStorageKey('showcase_child')),
        ],
      ),
    );
  }
}
