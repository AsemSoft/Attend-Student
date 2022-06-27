import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class DateTimeSelectorButton extends StatefulWidget {
  final void Function(DateTime) onDateTimeSelected;
  final String label;
  final EdgeInsets padding;
  final DateTime? initialDateTime;

  const DateTimeSelectorButton({
    Key? key,
    required this.onDateTimeSelected,
    this.label = "Tap to select date/time",
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    this.initialDateTime,
  }) : super(key: key);

  @override
  State<DateTimeSelectorButton> createState() => _DateTimeSelectorButtonState();
}

class _DateTimeSelectorButtonState extends State<DateTimeSelectorButton> {
  DateTime? _selectedDateTime;

  Future<void> _pickDateTime() async {
    await DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(const Duration(days: 30 * 12)),
      onConfirm: (picked) {
        setState(() => _selectedDateTime = picked);
        widget.onDateTimeSelected(_selectedDateTime!);
      },
      currentTime: DateTime.now(),
    );
  }

  @override
  void initState() {
    _selectedDateTime = widget.initialDateTime;
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
            const Icon(Icons.date_range),
            const SizedBox(width: 8),
            Text(
              _selectedDateTime != null
                  ? DateFormat.yMEd().add_Hm().format(_selectedDateTime!)
                  : widget.label,
            ),
          ],
        ),
      ),
      onPressed: _pickDateTime,
    );
  }
}
