import 'package:attend/providers/auth_provider.dart';
import 'package:attend/providers/courses_provider.dart';
import 'package:attend/util/dialogs_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/header_notification_line.dart';
import '../widgets/large_grid_card.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coursesProvider =
        Provider.of<CoursesProvider>(context, listen: false);
    final session = Provider.of<AuthProvider>(context).session;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (session != null)
              FutureBuilder<List<String>>(
                future: coursesProvider.getMessages(session.id),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!
                          .map((m) => HeaderNotificationLine(m))
                          .toList(),
                    );
                  } else if (snapshot.hasError) {
                    DialogsService.showSnackBar(
                      context,
                      'Could not fetch courses messages',
                    );
                  }

                  return const SizedBox();
                },
              ),
            const SizedBox(height: 32),
            LargeGridCard(
              onTap: () => {},
              color: const Color(0xff00695C),
              child: const Center(
                child: Text(
                  'My Courses',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: LargeGridCard(
                    onTap: () => {},
                    color: const Color(0xff386ba8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 16, left: 16),
                          child: const Text(
                            'Scan QR',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: LargeGridCard(
                    onTap: () => {},
                    color: const Color(0xffdd3370),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: 16,
                            left: 16,
                          ),
                          child: const Text(
                            'Attendance Hisotry',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LargeGridCard(
              onTap: () => {},
              color: const Color(0xff142b6b),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      'COMING SOON',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Live Classes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
