
import 'package:flutter/material.dart';

class LargeSubmitButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final double height;
  final EdgeInsets margin;
  final void Function() onPressed;

  const LargeSubmitButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.height = 60,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      margin: margin,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(fontSize: 22, letterSpacing: 2),
            ),
            const SizedBox(width: 16),
            Icon(icon, size: 32)
          ],
        ),
      ),
    );
  }
}