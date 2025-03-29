import 'dart:math' as math;
import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  final double progress;
  final double radius;
  final double strokeWidth;
  final List<Color> gradientColors;
  final Color backgroundColor;
  final String? centerText;
  final TextStyle? centerTextStyle;
  final bool addShadow;
  
  const ProgressRing({
    Key? key,
    required this.progress,
    required this.radius,
    required this.strokeWidth,
    required this.gradientColors,
    this.backgroundColor = Colors.grey,
    this.centerText,
    this.centerTextStyle,
    this.addShadow = true,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary,
    );
    
    final completeTextStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
    
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(radius * 2, radius * 2),
        painter: _ProgressRingPainter(
          progress: progress,
          strokeWidth: strokeWidth,
          gradientColors: gradientColors,
          backgroundColor: backgroundColor,
          addShadow: addShadow,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                centerText ?? '${(progress * 100).toInt()}%',
                style: centerTextStyle ?? defaultTextStyle,
              ),
              if (progress < 1.0 && progress > 0)
                Text(
                  'Complete',
                  style: completeTextStyle,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final List<Color> gradientColors;
  final Color backgroundColor;
  final bool addShadow;
  
  _ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.gradientColors,
    required this.backgroundColor,
    required this.addShadow,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    // Add shadow if enabled
    if (addShadow) {
      final shadowPaint = Paint()
        ..color = Colors.black.withAlpha(20)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      
      canvas.drawCircle(center, radius, shadowPaint);
    }
    
    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor.withAlpha(31)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Progress arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweepAngle = 2 * math.pi * progress;
    
    // Create gradient
    final gradientPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    
    if (gradientColors.length > 1) {
      gradientPaint.shader = SweepGradient(
        colors: [...gradientColors, gradientColors.first],
        tileMode: TileMode.clamp,
        startAngle: 0,
        endAngle: 2 * math.pi,
      ).createShader(rect);
    } else {
      gradientPaint.color = gradientColors.first;
    }
    
    // Draw the progress arc
    canvas.drawArc(
      rect,
      -math.pi / 2, // Start from top (90° offset)
      sweepAngle,
      false,
      gradientPaint,
    );
    
    // Draw small circle at the end of the progress arc for a nicer look
    if (progress > 0.02 && progress < 0.99) {
      final endAngle = -math.pi / 2 + sweepAngle;
      final endPoint = Offset(
        center.dx + radius * math.cos(endAngle),
        center.dy + radius * math.sin(endAngle),
      );
      
      // Draw a small circle at the end point
      if (gradientColors.length > 1) {
        // Get color at current position
        final colors = [...gradientColors, gradientColors.first];
        final colorPosition = (progress % 1.0) * (colors.length - 1);
        final colorIndex = colorPosition.floor();
        final colorLerp = colorPosition - colorIndex;
        final endColor = Color.lerp(
          colors[colorIndex], 
          colors[colorIndex + 1], 
          colorLerp
        )!;
        
        final dotPaint = Paint()
          ..color = endColor
          ..style = PaintingStyle.fill;
          
        canvas.drawCircle(endPoint, strokeWidth / 3, dotPaint);
      } else {
        final dotPaint = Paint()
          ..color = gradientColors.first
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(endPoint, strokeWidth / 3, dotPaint);
      }
    }
  }
  
  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gradientColors != gradientColors ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.addShadow != addShadow;
  }
} 