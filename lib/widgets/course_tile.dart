import 'package:attend/providers/courses_provider.dart';
import 'package:attend/util/dialogs_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes.dart' as routes;
import '../models/course.dart';
import '../models/session_user.dart';
import '../providers/auth_provider.dart';

class CourseTile extends StatelessWidget {
  final Course course;

  const CourseTile(
    this.course, {
    Key? key,
  }) : super(key: key);

  Future<void> _showCreateLectureScreen(
    BuildContext context,
    int courseId,
    _CourseOption type,
  ) async {
    final coursesProvider =
        Provider.of<CoursesProvider>(context, listen: false);

    final args = {'courseId': course.id};

    switch (type) {
      case _CourseOption.createOnlineLecture:
        Navigator.pushNamed(
          context,
          routes.editOnlineLectureScreen,
          arguments: args,
        );
        break;
      case _CourseOption.createOfflineLecture:
        Navigator.pushNamed(
          context,
          routes.editOfflineLectureScreen,
          arguments: args,
        );
        break;
      case _CourseOption.setMessage:
        await _displayTextInputDialog(context, (msg) async {
          await coursesProvider.setMessage(courseId, msg);
          course.message = msg;
        });
        break;
      case _CourseOption.removeMessage:
        await coursesProvider.removeMessage(courseId);
        course.message = null;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {},
        child: ClipRRect(
          child: Ink(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  blurRadius: 12,
                  offset: Offset(0, 0),
                  color: Color(0x33000000),
                  spreadRadius: .5,
                )
              ],
            ),
            child: Row(
              children: <Widget>[
                Text(
                  course.title,
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
                if (course.description != null) ...[
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.white54,
                    size: 32,
                  ),
                  Expanded(
                    child: Text(
                      course.description!,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ],
                authProvider.session!.role == UserRole.instructor
                    ? PopupMenuButton<_CourseOption>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        itemBuilder: (ctx) => [
                          PopupMenuItem<_CourseOption>(
                            child: Row(
                              children: const <Widget>[
                                Icon(Icons.wifi),
                                Text('  Create Online Lecture'),
                              ],
                            ),
                            value: _CourseOption.createOnlineLecture,
                          ),
                          PopupMenuItem<_CourseOption>(
                            child: Row(
                              children: const <Widget>[
                                Icon(Icons.airplanemode_active_outlined),
                                Text('  Create Offline Lecture'),
                              ],
                            ),
                            value: _CourseOption.createOfflineLecture,
                          ),
                          course.message == null
                              ? PopupMenuItem<_CourseOption>(
                                  child: Row(
                                    children: const <Widget>[
                                      Icon(Icons.message_outlined),
                                      Text('  Set Course Message'),
                                    ],
                                  ),
                                  value: _CourseOption.setMessage,
                                )
                              : PopupMenuItem<_CourseOption>(
                                  child: Row(
                                    children: const <Widget>[
                                      Icon(Icons.remove),
                                      Text('  Remove Course Message'),
                                    ],
                                  ),
                                  value: _CourseOption.removeMessage,
                                )
                        ],
                        onSelected: (value) =>
                            _showCreateLectureScreen(context, course.id, value),
                      )
                    : const Icon(
                        Icons.arrow_forward,
                        color: Colors.white54,
                        size: 32,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _displayTextInputDialog(
  BuildContext context,
  void Function(String) onSubmit,
) async {
  final controller = TextEditingController();

  return DialogsService.showAlertDialog(
    context,
    TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        filled: true,
        label: Text('Message'),
        hintText: 'New message text',
      ),
    ),
    title: const Text('Set course message'),
    primaryAction: (ctx) {
      if (controller.text.isEmpty) {
        DialogsService.showSnackBar(context, 'Message cannot be empty');
        return;
      }

      onSubmit(controller.text);
      Navigator.pop(ctx);
    },
    secondaryAction: (ctx) {
      Navigator.pop(ctx);
    },
    secondaryActionLabel: const Text('Cancel'),
  );
}

enum _CourseOption {
  createOnlineLecture,
  createOfflineLecture,
  setMessage,
  removeMessage,
}
