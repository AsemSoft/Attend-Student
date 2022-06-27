import 'package:flutter/material.dart';

class LargeGridCard extends StatelessWidget {
  final Widget child;
  final void Function() onTap;
  final Color color;

  const LargeGridCard({
    Key? key,
    required this.child,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 136,
        child: child,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: <BoxShadow>[
            BoxShadow(
                blurRadius: 12,
                offset: const Offset(0, 4),
                color: const Color(0xff000000).withOpacity(.25),
                spreadRadius: 2)
          ],
        ),
      ),
    );
  }
}
