import 'package:flutter/material.dart';

class Timeline extends StatelessWidget {
  final double position;
  final double duration;
  final ValueChanged<double>? onChanged;

  const Timeline({
    Key? key,
    required this.position,
    required this.duration,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ЗАЩИТА: Чтобы слайдер не падал, если длительность 0 или позиция вылетела за пределы
    double safeDuration = duration > 0 ? duration : 1.0;
    double safePosition = position.clamp(0.0, safeDuration);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.grey[600],
            thumbColor: Colors.white,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
          ),
          child: Slider(
            value: safePosition, // Используем безопасное значение
            min: 0.0,
            max: safeDuration,
            onChanged: (value) {
              if (onChanged != null) {
                onChanged!(value);
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(position),
                style: TextStyle(color: Colors.grey[300], fontSize: 12),
              ),
              Text(
                _formatDuration(duration),
                style: TextStyle(color: Colors.grey[300], fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(double seconds) {
    if (seconds < 0) seconds = 0;
    int minutes = (seconds / 60).floor();
    int remainingSeconds = (seconds % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}