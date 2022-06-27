import 'package:flutter/material.dart';

class HeaderNotificationLine extends StatelessWidget {
  final String message;

  const HeaderNotificationLine(
    this.message, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xffcce1de),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(children: <Widget>[
        const Icon(Icons.info_rounded),
        const SizedBox(width: 4),
        const SizedBox(width: 4),
        Text(message),
      ]),
    );
  }
}
