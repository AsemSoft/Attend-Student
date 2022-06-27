import 'package:flutter/material.dart';

class LectureTeacherHeader extends StatelessWidget {
  const LectureTeacherHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(children: [
          const CircleAvatar(radius: 14),
          const SizedBox(width: 12),
          Text(
            'Teacher\'s namex',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ]),
      ),
    );
  }
}
