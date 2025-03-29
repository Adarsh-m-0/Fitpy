import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

Future<void> main() async {
  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();
  
  // Define original and target file paths
  final originalLogoPath = 'assets/images/fitpy_logo.png';
  final originalAdaptivePath = 'assets/images/fitpy_logo_adaptive.png';
  final resizedLogoPath = 'assets/images/fitpy_logo.png';
  final resizedAdaptivePath = 'assets/images/fitpy_logo_adaptive.png';
  
  // Resize the icons with 50% smaller size and extra padding
  await resizeIcon(originalLogoPath, resizedLogoPath, scale: 0.5, padding: 0.25);
  await resizeIcon(originalAdaptivePath, resizedAdaptivePath, scale: 0.5, padding: 0.25);
  
  print('Icons resized successfully!');
  exit(0);
}

Future<void> resizeIcon(String sourcePath, String targetPath, {
  double scale = 0.5,
  double padding = 0.25,
}) async {
  // First, read from backup to make sure we're using the original image
  final backupPath = path.join(
    path.dirname(sourcePath), 
    'backup', 
    path.basename(sourcePath)
  );
  
  // Read the image file as bytes
  final ByteData imageData = await rootBundle.load(backupPath);
  final Uint8List bytes = imageData.buffer.asUint8List();
  
  // Decode the image
  final ui.Codec codec = await ui.instantiateImageCodec(bytes);
  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  final ui.Image image = frameInfo.image;
  
  // Calculate the new size with padding
  final int originalWidth = image.width;
  final int originalHeight = image.height;
  final int newWidth = originalWidth;
  final int newHeight = originalHeight;
  
  // Calculate scaled image size and position with padding
  final double scaledWidth = originalWidth * scale;
  final double scaledHeight = originalHeight * scale;
  final double paddingAmount = originalWidth * padding;
  
  // Create a PictureRecorder to draw the new image
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(recorder);
  
  // Draw transparent background
  canvas.drawColor(Colors.transparent, BlendMode.clear);
  
  // Calculate position to center the scaled image with padding
  final double left = (newWidth - scaledWidth) / 2;
  final double top = (newHeight - scaledHeight) / 2;
  
  // Draw the scaled image with padding
  canvas.drawImageRect(
    image,
    Rect.fromLTWH(0, 0, originalWidth.toDouble(), originalHeight.toDouble()),
    Rect.fromLTWH(left, top, scaledWidth, scaledHeight),
    Paint(),
  );
  
  // Convert to an image
  final ui.Picture picture = recorder.endRecording();
  final ui.Image resizedImage = await picture.toImage(newWidth, newHeight);
  
  // Convert the image to bytes
  final ByteData? resizedByteData = await resizedImage.toByteData(
    format: ui.ImageByteFormat.png,
  );
  
  if (resizedByteData == null) {
    throw Exception('Failed to convert image to bytes');
  }
  
  final Uint8List resizedBytes = resizedByteData.buffer.asUint8List();
  
  // Save the resized image
  final File targetFile = File(targetPath);
  await targetFile.writeAsBytes(resizedBytes);
  
  print('Resized $sourcePath to $targetPath (${scale * 100}% size with ${padding * 100}% padding)');
} 