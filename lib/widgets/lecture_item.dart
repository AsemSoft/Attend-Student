import '../routes.dart' as routes;
import 'package:attend/models/lecture.dart';
import 'package:attend/models/online_lecture.dart';
import 'package:attend/providers/courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LectureItem<T extends Lecture> extends StatelessWidget {
  final T lecture;

  const LectureItem(
    this.lecture, {
    Key? key,
  }) : super(key: key);

  String get _lectureTypeString => T == OnlineLecture ? 'Online' : 'Offline';
  String get _footerString => '$_lectureTypeString - ${lecture.timeString}';

  @override
  Widget build(BuildContext context) {
    final coursesProvider =
        Provider.of<CoursesProvider>(context, listen: false);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            T == OnlineLecture
                ? routes.onlineLectureDetailsScreen
                : routes.offlineLectureDetailsScreen,
            arguments: lecture,
          );
        },
        child: Ink(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //const SizedBox(height: 18,),
                Text(
                  coursesProvider.getItem(lecture.courseId).header,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      lecture.title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                Text(
                  _footerString,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 8,
                ),
                LinearProgressIndicator(
                  value: 30,
                  color: T == OnlineLecture ? Colors.green : Colors.blueGrey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
