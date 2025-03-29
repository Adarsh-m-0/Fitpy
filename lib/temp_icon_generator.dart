import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load the original icon
  final ByteData data = await rootBundle.load('assets/images/fitpy_logo.png');
  final Uint8List bytes = data.buffer.asUint8List();
  
  final ui.Codec codec = await ui.instantiateImageCodec(bytes);
  final ui.FrameInfo fi = await codec.getNextFrame();
  final ui.Image originalImage = fi.image;
  
  // Create a new image with extra padding
  final int originalSize = originalImage.width;
  final int newSize = originalSize;
  final double paddingRatio = 0.3; // 30% padding on each side
  final int paddingPixels = (originalSize * paddingRatio).round();
  final int newImageSize = originalSize - (paddingPixels * 2);
  
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(recorder);
  
  // Draw background (white or transparent)
  final paint = Paint()..color = Colors.transparent;
  canvas.drawRect(Rect.fromLTWH(0, 0, newSize.toDouble(), newSize.toDouble()), paint);
  
  // Draw original image with padding
  canvas.drawImageRect(
    originalImage,
    Rect.fromLTWH(0, 0, originalSize.toDouble(), originalSize.toDouble()),
    Rect.fromLTWH(
      paddingPixels.toDouble(),
      paddingPixels.toDouble(),
      newImageSize.toDouble(),
      newImageSize.toDouble(),
    ),
    Paint(),
  );
  
  final ui.Picture picture = recorder.endRecording();
  final ui.Image image = await picture.toImage(newSize, newSize);
  final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List pngBytes = byteData!.buffer.asUint8List();
  
  // Save the image
  File('temp_icons/fitpy_logo_padded.png').writeAsBytesSync(pngBytes);
  print('Padded icon created in temp_icons/fitpy_logo_padded.png');
} 