import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(const ToDo());
}

class ToDo extends StatelessWidget {
  const ToDo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasko',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // White background for the app
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // White background for the AppBar
          titleTextStyle: TextStyle(
              color: Colors.blue[800], fontSize: 20), // Dark blue title text
          iconTheme: IconThemeData(
              color: Colors.blue[800]), // Dark blue for icons in AppBar
        ),
      ),
      home: HomePage(),
    );
  }
}
