import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
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
        elevation: 2,
        minimumSize: const Size(size, size),
      ),
      onPressed: onPressed,
      child: const Icon(
        Icons.menu,
        size: size / 2,
      ),
    );
  }
}
