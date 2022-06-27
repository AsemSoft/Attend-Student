import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final EdgeInsets padding;

  const SectionHeader({
    Key? key,
    required this.title,
    this.actions,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          if (actions != null) ...actions!
        ],
      ),
    );
  }
}
