import 'package:flutter/material.dart';

class UserHeader extends StatelessWidget {
  final String username;

  const UserHeader({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const CircleAvatar(radius: 14),
        const SizedBox(width: 12),
        Text(
          'Hello, $username!',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
