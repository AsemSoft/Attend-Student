import 'package:flutter/material.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:intl/intl.dart';

import '../util/dialogs_service.dart';

class DurationSelectorButton extends StatefulWidget {
  final void Function(Duration) onDurationSelected;
  final String label;
  final EdgeInsets padding;
  final Duration? initialDuration;

  const DurationSelectorButton({
    Key? key,
    required this.onDurationSelected,
    this.label = "Tap to select duration",
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    this.initialDuration,
  }) : super(key: key);

  @override
  State<DurationSelectorButton> createState() => _DurationSelectorButtonState();
}

class _DurationSelectorButtonState extends State<DurationSelectorButton> {
  Duration? _selectedDuration;

  Future<void> _pickDuration() async {
    final dur = await showDurationPicker(
      context: context,
      initialTime: _selectedDuration ?? const Duration(minutes: 60),
    );

    if (dur != null) {
      widget.onDurationSelected(dur);
      setState(() => _selectedDuration = dur);
    }
  }

  @override
  void initState() {
    _selectedDuration = widget.initialDuration;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(   
      child: Padding(
        padding: widget.padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.access_time_sharp),
            const SizedBox(width: 8),
            Text(
              _selectedDuration != null
                  ? '${_selectedDuration!.inMinutes} minutes'
                  : widget.label,
            ),
          ],
        ),
      ),
      onPressed: _pickDuration,
    );
  }
}
