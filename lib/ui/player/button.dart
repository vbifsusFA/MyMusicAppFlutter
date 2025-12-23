import 'package:flutter/material.dart';

class PlayerButton extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onPressed;
  final double size;

  const PlayerButton({
    Key? key,
    this.imageUrl,
    this.onPressed,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: size * 0.6,
                );
              },
            ),
          ),
        ),
      );
    } else {
      // Default button if no image URL is provided
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: size * 0.6,
          ),
        ),
      );
    }
  }
}