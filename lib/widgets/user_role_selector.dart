import 'package:attend/models/session_user.dart';
import 'package:flutter/material.dart';

class UserRoleSelector extends StatefulWidget {
  final UserRole initRole;
  final void Function(UserRole) onChanged;

  const UserRoleSelector({
    Key? key,
    this.initRole = UserRole.student,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<UserRoleSelector> createState() => _UserRoleSelectorState();
}

class _UserRoleSelectorState extends State<UserRoleSelector> {
  UserRole? selectedRole;

  @override
  void initState() {
    selectedRole = widget.initRole;
    super.initState();
  }

  ChoiceChip _createChoiceChip(IconData icon, String label, UserRole role) {
    return ChoiceChip(
      selected: role == selectedRole,
      selectedColor: Theme.of(context).primaryColor,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            size: 16,
            color: role == selectedRole ? Colors.white : Colors.black,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: role == selectedRole ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
      onSelected: (_) {
        widget.onChanged(role);
        setState(() => selectedRole = role);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      children: <Widget>[
        _createChoiceChip(Icons.school_outlined, 'Student', UserRole.student),
        _createChoiceChip(
            Icons.class__outlined, 'Instructor', UserRole.instructor),
        _createChoiceChip(
            Icons.admin_panel_settings_outlined, 'Admin', UserRole.admin),
      ],
    );
  }
}
