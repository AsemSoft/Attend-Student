import 'package:attend/models/user.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final User user;
  final void Function()? onTap;

  const UserTile(
    this.user, {
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const CircleAvatar(),
      title: Text(user.fullName),
      subtitle: Text(user.email),
    );
  }
}
