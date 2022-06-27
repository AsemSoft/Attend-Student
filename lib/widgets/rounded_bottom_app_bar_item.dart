import 'package:flutter/material.dart';

class RoundedBottomAppBarItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function() onClick;
  final bool isSelected;

  const RoundedBottomAppBarItem({
    Key? key,
    required this.label,
    required this.icon,
    required this.onClick,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemColor = isSelected ? Colors.white.withAlpha(210) : Colors.white54;

    return isSelected
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextButton(
              onPressed: onClick,
              child: Row(
                children: <Widget>[
                  Icon(icon, color: itemColor),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: itemColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(16)),
          )
        : IconButton(
            onPressed: onClick,
            icon: Icon(
              icon,
              color: itemColor,
            ),
          );
  }
}

class NavigationItem {
  final String label;
  final IconData icon;
  final void Function(int) onClick;

  const NavigationItem({
    required this.label,
    required this.icon,
    required this.onClick,
  });
}
