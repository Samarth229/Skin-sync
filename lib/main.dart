import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/pages/homepage.dart';  // Ensure correct path
import 'package:firebase_core/firebase_core.dart';  // Import Firebase package

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase before running the app
  await Firebase.initializeApp();

  // Load theme preference before running the app
  final prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool('isDarkMode') ?? false;  // Default to light mode if no preference

  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;

  const MyApp({super.key, required this.isDarkMode});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  // Toggle Dark Mode
  void _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = value;
    });
    prefs.setBool('isDarkMode', _isDarkMode); // Save the updated preference
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkinSync',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,  // Switch between light and dark mode
      darkTheme: ThemeData.dark(),  // Dark theme
      theme: ThemeData.light(),  // Light theme
      home: HomePage(toggleDarkMode: _toggleDarkMode), // Pass toggle function to HomePage
    );
  }
}



