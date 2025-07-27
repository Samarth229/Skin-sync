import 'dart:typed_data';
import 'package:image/image.dart' as img;

Future<Uint8List> preprocessImage(Uint8List imageData) async {
  // Decode image from bytes
  img.Image? image = img.decodeImage(imageData);
  if (image == null) {
    throw Exception("Failed to decode image");
  }

  // Resize image to 128x128
  img.Image resized = img.copyResize(image, width: 128, height: 128);

  // Convert to float32 and normalize pixels (0-255 → 0-1)
  List<double> imageMatrix = [];

  for (int y = 0; y < 128; y++) {
    for (int x = 0; x < 128; x++) {
      img.Pixel pixel = resized.getPixel(x, y);

      imageMatrix.add(pixel.r / 255.0); // Extract red
      imageMatrix.add(pixel.g / 255.0); // Extract green
      imageMatrix.add(pixel.b / 255.0); // Extract blue
    }
  }

  // Convert List<double> to Float32List for TensorFlow Lite
  return Float32List.fromList(imageMatrix).buffer.asUint8List();
}
