import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:test_app/pages/camera_screen.dart'; // Correct Import

class CameraPage extends StatefulWidget {
  final Function(bool) toggleDarkMode; // ✅ Accept toggle function

  const CameraPage({super.key, required this.toggleDarkMode});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> cameras = [];
  bool _isCameraInitialized = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        setState(() {
          _isCameraInitialized = true;
          _isLoading = false;
        });
      } else {
        print("❌ No cameras found!");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("❌ Error initializing camera: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _openCamera(CameraDescription selectedCamera) {
    if (_isCameraInitialized) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(
            camera: selectedCamera,
            toggleDarkMode: widget.toggleDarkMode, // ✅ Pass toggle function
          ),
        ),
      );
    } else {
      print("⚠️ Cameras are not initialized yet!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cameras are not initialized yet!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smile Please 😊")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _openCamera(cameras.first), // Front camera
              child: Column(
                children: [
                  Image.asset('lib/assets/frontface.jpg', width: 250, height: 250),
                  const SizedBox(height: 10),
                  const Text(
                    "Front Face",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () => _openCamera(cameras.last), // Back/side camera
              child: Column(
                children: [
                  Image.asset('lib/assets/sideface.jpg', width: 250, height: 250),
                  const SizedBox(height: 10),
                  const Text(
                    "Side Face",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}









