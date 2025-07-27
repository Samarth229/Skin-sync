import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:test_app/pages/image_preprocessing.dart'; // Image preprocessing
import 'package:test_app/pages/tflite_helper.dart'; // TensorFlow Lite model

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  final Function(bool) toggleDarkMode; // ✅ Accept toggleDarkMode function

  const CameraScreen({
    super.key,
    required this.camera,
    required this.toggleDarkMode,
  });

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isProcessing = false;
  bool _isModelLoaded = false;
  String _predictionResult = "No prediction yet";
  final TFLiteHelper tfliteHelper = TFLiteHelper();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadTFLiteModel();
  }

  /// 📌 Load the TensorFlow Lite model
  Future<void> _loadTFLiteModel() async {
    print("⏳ Loading TFLite model...");
    await tfliteHelper.loadModel();
    setState(() {
      _isModelLoaded = true;
    });
    print("✅ Model Loaded Successfully!");
  }

  /// 🎥 Initialize the camera
  Future<void> _initializeCamera() async {
    try {
      _controller?.dispose();

      _controller = CameraController(
        widget.camera,
        ResolutionPreset.medium,
      );

      await _controller!.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print("❌ Error initializing camera: $e");
    }
  }

  /// 📸 Capture the image and run skin type prediction
  Future<void> _captureAndPredict() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      print("❌ Camera not ready!");
      return;
    }

    if (!_isModelLoaded) {
      print("❌ Model is still loading...");
      setState(() {
        _predictionResult = "Model is still loading, please wait...";
      });
      return;
    }

    try {
      setState(() {
        _isProcessing = true;
        _predictionResult = "Processing image...";
      });

      final XFile imageFile = await _controller!.takePicture();
      Uint8List imageBytes = await imageFile.readAsBytes();

      Uint8List processedImage = await preprocessImage(imageBytes);

      String prediction = await tfliteHelper.runModel(processedImage);

      setState(() {
        _isProcessing = false;
        _predictionResult = "Skin Type: $prediction";
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _predictionResult = "Error: $e";
      });
      print("❌ Error capturing image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera Screen"),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              // Toggle dark mode manually if needed
              final isDark = Theme.of(context).brightness == Brightness.dark;
              widget.toggleDarkMode(!isDark); // ✅ Call the function
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _controller != null && _controller!.value.isInitialized
                ? CameraPreview(_controller!)
                : const Center(child: CircularProgressIndicator()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _isProcessing ? null : _captureAndPredict,
                child: const Text("Capture & Predict 📸"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_isProcessing) const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              _predictionResult,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    tfliteHelper.close();
    super.dispose();
  }
}




