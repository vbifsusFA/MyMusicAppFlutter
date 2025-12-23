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
    final double progress = duration > 0 ? position / duration : 0.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.grey[600],
            thumbColor: Colors.white,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 12.0),
          ),
          child: Slider(
            value: position,
            min: 0.0,
            max: duration,
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
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

  String _formatDuration(double duration) {
    int minutes = (duration / 60).floor();
    int seconds = (duration % 60).floor();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}