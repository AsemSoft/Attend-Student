import 'package:attend/models/course.dart';
import 'package:attend/models/lecture.dart';
import 'package:attend/providers/crud_provider.dart';
import 'package:attend/screens/edit_offline_lecture_screen.dart';
import 'package:attend/screens/edit_online_lecture_screen.dart';
import 'package:attend/screens/scan_qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import './routes.dart' as routes;
import './config.dart';
import '../services/http_context.dart';
import '../services/courses_service.dart';
import '../services/users_service.dart';
import '../providers/auth_provider.dart';
import '../providers/courses_provider.dart';
import '../providers/users_provider.dart';
import '../providers/online_lectures_provider.dart';
import '../providers/offline_lectures_provider.dart';
import '../services/online_lectures_service.dart';
import '../services/offline_lectures_service.dart';
import '../screens/login_screen.dart';
import '../screens/edit_course_screen.dart';
import '../screens/edit_user_screen.dart';
import '../screens/lecture_details_screen.dart';
import '../screens/home_screen.dart';
import '../models/offline_lecture.dart';
import '../models/online_lecture.dart';

void main() => runApp(AttendApp());

class AttendApp extends StatelessWidget {
  final HttpContext _ctx = HttpContext('http://10.0.2.2:5032');

  // why we write ip :10.0.2.2
  // local host is always = 127.0.0.1 but in dart will replace with 10.0.2.2
  AttendApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onlineLecturesProvider = OnlineLecturesProvider(
        OnlineLecturesService(_ctx, '/api/online-lectures'));
    final offlineLecturesProvider = OfflineLecturesProvider(
        OfflineLecturesService(_ctx, '/api/offline-lectures'));

    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider(create: (ctx) => AuthProvider(_ctx)),
        ChangeNotifierProvider(create: (ctx) => UsersProvider(UsersSerivce(_ctx, '/api/users'))),
        ChangeNotifierProvider(create: (ctx) => CoursesProvider(CoursesSerivce(_ctx, '/api/courses'))),
        ChangeNotifierProvider<OnlineLecturesProvider>.value(value: onlineLecturesProvider),
        ChangeNotifierProvider<OfflineLecturesProvider>.value(
            value: offlineLecturesProvider),
        ChangeNotifierProvider<CrudProvider<OnlineLecture>>.value(value: onlineLecturesProvider),
        ChangeNotifierProvider<CrudProvider<OfflineLecture>>.value(value: offlineLecturesProvider),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Attend',
        theme: ThemeData(
          primaryColor: primaryColor,
          primaryColorDark: primaryDarkColor,
          primaryColorLight: primaryLightColor,

          // bottom navigation bar
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: primaryDarkColor,
            unselectedItemColor: Colors.white70,
            elevation: 8,
            showUnselectedLabels: false,
            enableFeedback: true,
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: secondaryColor,
            primary: primaryColor,
          ),
        ),
        initialRoute: routes.loginScreen,
        routes: {
          routes.homeScreen: (ctx) => const HomeScreen(),
          routes.loginScreen: (ctx) => const LoginScreen(),
          routes.editUserScreen: (ctx) => const EditUserScreen(),
          routes.editCourseScreen: (ctx) => const EditCourseScreen(),
          routes.scanQrScreen: (ctx) => const ScanQrScreen(),
        },
        onGenerateRoute: (settings) {

          switch (settings.name) {
            case routes.onlineLectureDetailsScreen:

            case routes.offlineLectureDetailsScreen:
              return _buildRoute(
                LectureDetailsScreen<OfflineLecture>(
                  settings.arguments! as OfflineLecture,
                ),
              );
            case routes.editOnlineLectureScreen:
              final args = _EditLectureScreenArgs.fromArgs(settings.arguments);
              return _buildRoute(EditOnlineLectureScreen(
                args.courseId,
                lecture: args.lecture as OnlineLecture?,
              ));
            case routes.editOfflineLectureScreen:
              final args = _EditLectureScreenArgs.fromArgs(settings.arguments);
              return _buildRoute(EditOfflineLectureScreen(
                args.courseId,
                lecture: args.lecture as OfflineLecture?,
              ));
          }

          return null;
        },
      ),
    );
  }
}

MaterialPageRoute _buildRoute<T extends Widget>(T widget) {
  return MaterialPageRoute(builder: (ctx) => widget);
}

class _EditLectureScreenArgs<T extends Lecture> {
  final int courseId;
  final T? lecture;

  const _EditLectureScreenArgs(this.courseId, this.lecture);

  factory _EditLectureScreenArgs.fromArgs(Object? args) {
    if (args == null) {
      throw Exception('args must not be null');
    }

    final map = args as Map<String, dynamic>;

    return _EditLectureScreenArgs<T>(
      map['courseId']! as int,
      map['lecture'] as T?,
    );
  }
}
