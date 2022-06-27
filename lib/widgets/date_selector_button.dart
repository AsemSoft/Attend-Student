import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelectorButton extends StatefulWidget {
  final void Function(DateTime) onDateSelected;
  final String label;
  final EdgeInsets padding;
  final DateTime? initialDate;

  const DateSelectorButton({
    Key? key,
    required this.onDateSelected,
    this.label = "Tap to select date",
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    this.initialDate,
  }) : super(key: key);

  @override
  State<DateSelectorButton> createState() => _DateSelectorButtonState();
}

class _DateSelectorButtonState extends State<DateSelectorButton> {
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.initialDate ?? DateTime.now(),
        initialDatePickerMode: DatePickerMode.year,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());

    if (picked != null) {
      setState(() => _selectedDate = picked);
      widget.onDateSelected(_selectedDate!);
    }
  }

  @override
  void initState() {
    _selectedDate = widget.initialDate;
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
              _selectedDate != null
                  ? DateFormat.yMd().format(_selectedDate!)
                  : widget.label,
            ),
          ],
        ),
      ),
      onPressed: _pickDate,
    );
  }
}
