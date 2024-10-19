import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  List<NavigationDestination> appBarDestinations = const [
    NavigationDestination(
      icon: Icon(Icons.task),
      label: 'Pending Tasks',
      selectedIcon: Icon(Icons.task),
    ),
    NavigationDestination(
      icon: Icon(Icons.check),
      label: 'Completed Tasks',
      selectedIcon: Icon(Icons.check),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      const Center(
          child: Text('Pending Page', style: TextStyle(fontSize: 32.0))),
      const Center(
          child: Text('Completed Page', style: TextStyle(fontSize: 32.0))),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasko'),
      ),
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: appBarDestinations,
      ), // Don't show bottom navigation on larger screens
    );
  }
}
