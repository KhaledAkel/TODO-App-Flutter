import 'package:flutter/material.dart';
import 'home.dart';

/// The entry point of the Tasko application.
/// It initializes the app and displays the `ToDo` widget.
void main() {
  runApp(const ToDo());
}

/// The `ToDo` widget represents the root of the Tasko app.
/// It sets up the MaterialApp with a custom theme and defines the home screen.
class ToDo extends StatelessWidget {
  const ToDo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasko', // The title of the app
      debugShowCheckedModeBanner:
          false, // Removes the debug banner in debug mode
      theme: ThemeData(
        scaffoldBackgroundColor: Colors
            .white, // Sets the background color to white for the entire app
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // White background for the AppBar
          titleTextStyle: TextStyle(
              color: Colors.blue[800],
              fontSize: 20), // Style for AppBar title with dark blue color
          iconTheme: IconThemeData(
              color:
                  Colors.blue[800]), // Dark blue color for icons in the AppBar
        ),
      ),
      home: HomePage(), // Sets the HomePage as the starting screen of the app
    );
  }
}
