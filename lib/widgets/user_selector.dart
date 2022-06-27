import 'package:attend/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/session_user.dart';
import '../models/user.dart';
import '../providers/users_provider.dart';
import '../util/dialogs_service.dart';

class UserSelector extends StatefulWidget {
  final UserRole role;
  final void Function(User) onUserSelected;
  final String prompt;
  final User? initUser;

  const UserSelector(
      {Key? key,
      required this.role,
      required this.onUserSelected,
      this.prompt = "Select user",
      this.initUser})
      : super(key: key);

  @override
  State<UserSelector> createState() => _UserSelectorState();
}

class _UserSelectorState extends State<UserSelector> {
  User? _selectedUser;

  Future<void> _selectUser() async {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final ret = await DialogsService.showFutureChoiceDialog(
      context,
      usersProvider.loadByCategory(widget.role),
      (i, _) => UserTile((i as User)),
      title: Text(widget.prompt),
    );

    if (ret != null) {
      setState(() => _selectedUser = ret);
      widget.onUserSelected(ret);
    }
  }

  @override
  void initState() {
    _selectedUser = widget.initUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _selectedUser == null
        ? SizedBox(
            height: 60,
            width: double.infinity,
            child: TextButton(
              onPressed: _selectUser,
              child: Text('${widget.prompt}...'),
            ),
          )
        : UserTile(
            _selectedUser!,
            onTap: _selectUser,
          );
  }
}
