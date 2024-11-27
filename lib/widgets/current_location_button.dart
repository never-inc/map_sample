import 'package:flutter/material.dart';

class CurrentLocationButton extends StatelessWidget {
  const CurrentLocationButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const size = 48.0;
    return FilledButton(
      style: FilledButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueAccent,
        elevation: 2,
        minimumSize: const Size(size, size),
      ),
      onPressed: onPressed,
      child: const Icon(
        Icons.my_location,
        size: size / 2,
      ),
    );
  }
}
