import 'package:flutter/material.dart';
import 'timeline.dart';
import 'volume.dart';

class BottomPlayer extends StatelessWidget {
  final bool isPlaying; // Теперь передаем состояние напрямую
  final VoidCallback? onPlayPressed;
  final VoidCallback? onNextPressed;
  final VoidCallback? onPrevPressed;
  final ValueChanged<double>? onPositionChanged;
  final double volume;
  final ValueChanged<double>? onVolumeChanged;
  final double position;
  final double duration;

  const BottomPlayer({
    Key? key,
    required this.isPlaying,
    this.onPlayPressed,
    this.onNextPressed,
    this.onPrevPressed,
    this.onPositionChanged,
    required this.volume,
    this.onVolumeChanged,
    required this.position,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Немного увеличим для удобства
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[900], // Сделаем чуть темнее
        boxShadow: [
          BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, -2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              // Кнопка Назад
              IconButton(
                icon: const Icon(Icons.skip_previous_rounded, color: Colors.white, size: 32),
                onPressed: onPrevPressed,
              ),
              // Кнопка Плей / Пауза
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                  color: Colors.blueAccent,
                  size: 48,
                ),
                onPressed: onPlayPressed,
              ),
              // Кнопка Вперед
              IconButton(
                icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 32),
                onPressed: onNextPressed,
              ),
              
              // Ползунок трека (Timeline)
              Expanded(
                child: Timeline(
                  position: position,
                  duration: duration,
                  onChanged: onPositionChanged,
                ),
              ),
              
              // Громкость (Volume)
              SizedBox(
                width: 100,
                child: VolumeControl(
                  volume: volume,
                  onChanged: onVolumeChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}