import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteHelper {
  Interpreter? _interpreter;
  bool _isModelLoaded = false; // ✅ Track model loading status

  /// ✅ Load the TFLite Model (Called Once)
  Future<void> loadModel() async {
    try {
      print("⏳ Loading TFLite Model...");
      _interpreter = await Interpreter.fromAsset("Model/skin_classifier_model.tflite"); // ✅ Correct path
      _isModelLoaded = true;
      print("✅ Model Loaded Successfully!");
    } catch (e) {
      print("❌ Model Load Error: $e");
      _isModelLoaded = false;
    }
  }

  /// ✅ Run Inference on an Image
  Future<String> runModel(Uint8List inputImage) async {
    if (!_isModelLoaded || _interpreter == null) {
      print("❌ Error: Model is not loaded! Call `loadModel()` first.");
      return "Error";
    }

    try {
      print("🔄 Preprocessing image...");

      // ✅ Convert Uint8List to Float32List (Normalize to [0,1] range)
      Float32List floatInput = Float32List(inputImage.length);
      for (int i = 0; i < inputImage.length; i++) {
        floatInput[i] = inputImage[i] / 255.0;
      }

      // ✅ Ensure the input tensor shape matches the model
      var input = floatInput.reshape([1, 128, 128, 3]); // [Batch, Height, Width, Channels]
      var output = List.generate(1, (_) => List.filled(3, 0.0)); // [Batch, Classes]

      print("📤 Running inference...");
      _interpreter!.run(input, output);

      List<double> probabilities = output[0].cast<double>();
      print("📊 Model Output Probabilities: $probabilities");

      // ✅ Interpret Results (Assuming: 0 = Dry, 1 = Oily, 2 = Normal)
      List<String> skinTypes = ["Dry", "Oily", "Normal"];
      int maxIndex = probabilities.indexOf(probabilities.reduce((a, b) => a > b ? a : b));

      print("🎯 Predicted Skin Type: ${skinTypes[maxIndex]}");
      return skinTypes[maxIndex];

    } catch (e) {
      print("❌ Model Inference Error: $e");
      return "Error";
    }
  }

  /// ✅ Close Interpreter
  void close() {
    if (_interpreter != null) {
      try {
        _interpreter!.close();
        _interpreter = null;
        _isModelLoaded = false;
        print("🔻 Model Closed Successfully!");
      } catch (e) {
        print("⚠️ Error Closing Model: $e");
      }
    }
  }
}

