import 'package:flutter/material.dart';
import 'button.dart';
import 'timeline.dart';
import 'volume.dart';

class BottomPlayer extends StatefulWidget {
  final String? playButtonImageUrl;
  final String? pauseButtonImageUrl;
  final String? nextButtonImageUrl;
  final String? prevButtonImageUrl;
  final VoidCallback? onPlayPressed;
  final VoidCallback? onPausePressed;
  final VoidCallback? onNextPressed;
  final VoidCallback? onPrevPressed;
  final ValueChanged<double>? onPositionChanged;
  final double? volume;
  final ValueChanged<double>? onVolumeChanged;
  final double? position;
  final double? duration;

  const BottomPlayer({
    Key? key,
    this.playButtonImageUrl,
    this.pauseButtonImageUrl,
    this.nextButtonImageUrl,
    this.prevButtonImageUrl,
    this.onPlayPressed,
    this.onPausePressed,
    this.onNextPressed,
    this.onPrevPressed,
    this.onPositionChanged,
    this.volume,
    this.onVolumeChanged,
    this.position,
    this.duration,
  }) : super(key: key);

  @override
  _BottomPlayerState createState() => _BottomPlayerState();
}

class _BottomPlayerState extends State<BottomPlayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Previous button
          PlayerButton(
            imageUrl: widget.prevButtonImageUrl,
            onPressed: widget.onPrevPressed,
            size: 30,
          ),
          // Play/Pause button
          PlayerButton(
            imageUrl: widget.playButtonImageUrl,
            onPressed: widget.onPlayPressed,
            size: 48,
          ),
          // Next button
          PlayerButton(
            imageUrl: widget.nextButtonImageUrl,
            onPressed: widget.onNextPressed,
            size: 30,
          ),
          // Timeline
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Timeline(
                position: widget.position ?? 0.0,
                duration: widget.duration ?? 100.0,
                onChanged: widget.onPositionChanged,
              ),
            ),
          ),
          // Volume control
          SizedBox(
            width: 80,
            child: VolumeControl(
              volume: widget.volume ?? 0.5,
              onChanged: widget.onVolumeChanged,
            ),
          ),
        ],
      ),
    );
  }
}
