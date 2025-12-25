import 'package:flutter/material.dart';

class VolumeControl extends StatelessWidget {
  final double volume;
  final ValueChanged<double>? onChanged;

  const VolumeControl({
    Key? key,
    required this.volume,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          volume > 0 ? Icons.volume_up : Icons.volume_mute,
          color: Colors.white,
          size: 16,
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.grey[600],
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
            ),
            child: Slider(
              value: volume.clamp(0.0, 1.0), // Клэмпим громкость от 0 до 1
              min: 0.0,
              max: 1.0,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}