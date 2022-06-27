import 'package:flutter/material.dart';

class SwitchTile extends StatefulWidget {
  final String label;
  final bool initValue;
  final void Function(bool) onChanged;

  const SwitchTile({
    Key? key,
    required this.label,
    required this.onChanged,
    this.initValue = false,
  }) : super(key: key);

  @override
  State<SwitchTile> createState() => _SwitchTileState();
}

class _SwitchTileState extends State<SwitchTile> {
  bool? isSelected;

  @override
  void initState() {
    isSelected = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(widget.label),
      value: isSelected!,
      onChanged: (x) {
        widget.onChanged(x);
        setState(() => isSelected = x);
      },
    );
  }
}
