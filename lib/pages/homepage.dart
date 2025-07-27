import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/pages/camerapage.dart';
import 'package:test_app/pages/profile.dart';
import 'package:test_app/pages/productrecommendation.dart';
import 'package:test_app/pages/email.dart'; // Import EmailPage

class HomePage extends StatefulWidget {
  final Function(bool) toggleDarkMode; // Accept function to toggle dark mode

  const HomePage({super.key, required this.toggleDarkMode}); // Pass the toggleDarkMode function through constructor

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDarkMode = false; // Track dark mode state

  @override
  void initState() {
    super.initState();
    _loadThemePreference(); // Load the saved theme preference
  }

  // Load the saved theme preference from SharedPreferences
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false; // Load the preference
    });
  }

  // Save the theme preference to SharedPreferences
  Future<void> _saveThemePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value); // Save the preference
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Skin Sync"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode; // Toggle Dark Mode
              });
              widget.toggleDarkMode(isDarkMode); // Call the toggle function passed from the main app
              _saveThemePreference(isDarkMode); // Save the new preference
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'lib/assets/logo.png', // Path to the background image
              fit: BoxFit.cover, // Ensure the image covers the whole screen
            ),
          ),
          // Content Layer (without the "Welcome to SkinSync" text)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // No text here anymore
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // Navigate to HomePage with dark mode state
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(toggleDarkMode: widget.toggleDarkMode),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () {
                // Navigate to CameraPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraPage(toggleDarkMode: widget.toggleDarkMode),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                // Navigate to ProfilePage with dark mode state
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(toggleDarkMode: widget.toggleDarkMode),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.recommend),
              onPressed: () {
                // Navigate to ProductRecommendationPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductRecommendationPage(toggleDarkMode: widget.toggleDarkMode),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 





