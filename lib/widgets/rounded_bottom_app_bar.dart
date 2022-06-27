import 'package:flutter/material.dart';

import 'rounded_bottom_app_bar_item.dart';

class RoundedBottomAppBar extends StatelessWidget {
  final List<NavigationItem> items;
  final int selectedIndex;

  const RoundedBottomAppBar({
    Key? key,
    required this.items,
    this.selectedIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationItems = items.asMap().entries.map((e) {
      // ignore: unnecessary_cast
      return (RoundedBottomAppBarItem(
        label: e.value.label,
        icon: e.value.icon,
        onClick: () => e.value.onClick(e.key),
        isSelected: e.key == selectedIndex,
      ) as Widget);
    }).toList();

    navigationItems.add(const SizedBox(width: 48));

    return Container(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
        child: BottomAppBar(
          color: Theme.of(context).primaryColorDark,
          notchMargin: 8,
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: navigationItems,
            ),
          ),
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const <BoxShadow>[
            BoxShadow(
                blurRadius: 8,
                offset: Offset(0, -4),
                color: Color(0x2f414141),
                spreadRadius: 2)
          ],
        ),
    );
  }
}
