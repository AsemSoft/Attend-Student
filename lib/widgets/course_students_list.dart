import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../services/http_error.dart';
import '../util/dialogs_service.dart';
import '../extensions/string_extensions.dart';
import '../providers/courses_provider.dart';

class CourseStudentsList extends StatefulWidget {
  final int courseId;

  const CourseStudentsList({
    Key? key,
    required this.courseId,
  }) : super(key: key);

  @override
  State<CourseStudentsList> createState() => _CourseStudentsListState();
}

class _CourseStudentsListState extends State<CourseStudentsList> {
  bool _isStarted = false;

  @override
  Widget build(BuildContext context) {
    final coursesProvider = Provider.of<CoursesProvider>(context);

    return !_isStarted
        ? Container(
          margin: const EdgeInsets.symmetric(horizontal: 18),
          child: OutlinedButton(
            onPressed: () => setState(() => _isStarted = true),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Load enrolled students'),
                    SizedBox(width: 18),
                    Icon(Icons.more_horiz),
                  ],
                ),
            ),
          ),
        )
        : FutureBuilder<List<User>>(
            future: coursesProvider.getEnrolledStudents(widget.courseId),
            builder: (ctx, snapshot) {
              if (snapshot.hasError) {
                return const Text('Could not load students');
              } else if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (ctx, i) {
                    final user = snapshot.data![i];
                    return ListTile(
                      onTap: () {},
                      leading: const CircleAvatar(),
                      title: Text(user.fullName),
                      subtitle: Text(user.email),
                      trailing: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.clear),
                        color: Colors.red,
                        onPressed: () async {
                          final ret = await DialogsService.showQuestionDialog(
                            context,
                            Text(
                              'Are you sure you want to unenroll student `${user.fullName}\'?',
                            ),
                            title: const Text('Confirm removal'),
                          );

                          if (ret ?? false) {
                            try {
                              await coursesProvider.unenrollStudent(
                                widget.courseId,
                                user,
                              );
                            } on HttpError catch (ex) {
                              DialogsService.showSnackBar(
                                  context, ex.message.capitalize());
                            }

                            DialogsService.showSnackBar(
                              context,
                              'Student unenrolled',
                            );
                          }
                        },
                      ),
                    );
                  },
                );
              } else {
                return const SizedBox(
                  height: 64,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          );
  }
}
