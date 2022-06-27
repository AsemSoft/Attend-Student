import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../extensions/string_extensions.dart';
import '../models/attendance_request.dart';
import '../models/lecture.dart';
import '../models/offline_lecture.dart';
import '../models/online_lecture.dart';
import '../models/session_user.dart';
import '../providers/auth_provider.dart';
import '../providers/crud_provider.dart';
import '../providers/offline_lectures_provider.dart';
import '../providers/online_lectures_provider.dart';
import '../services/http_error.dart';
import '../util/dialogs_service.dart';
import '../widgets/section_header.dart';
import '../routes.dart' as routes;

class LectureDetailsScreen<T extends Lecture> extends StatefulWidget {
  final T lecture;

  const LectureDetailsScreen(this.lecture, {Key? key}) : super(key: key);

  @override
  State<LectureDetailsScreen<T>> createState() =>
      _LectureDetailsScreenState<T>();
}

class _LectureDetailsScreenState<T extends Lecture>
    extends State<LectureDetailsScreen<T>> {
  final List<AttendanceRequest> _currentAttendees = [];

  T? _lecture;
  AttendanceRequest? _currentReq;
  bool _isLoading = false;

  Future<void> _refresh() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() => _isLoading = true);

    _currentAttendees.clear();

    if (T == OfflineLecture) {
      final lecturesProvider =
          Provider.of<OfflineLecturesProvider>(context, listen: false);
      _currentAttendees
          .addAll(await lecturesProvider.getAttendanceRequests(_lecture!.id));
    } else {
      final lecturesProvider =
          Provider.of<OnlineLecturesProvider>(context, listen: false);
      _currentAttendees
          .addAll(await lecturesProvider.getAttendanceRequests(_lecture!.id));
    }

    if (_currentAttendees
        .any((r) => r.requestedBy.username == authProvider.session!.username)) {
      _currentReq = _currentAttendees.firstWhere(
        (r) => r.requestedBy.username == authProvider.session!.username,
      );
    }

    setState(() => _isLoading = false);
  }

  Future<void> _signin() async {
    try {
      if (T == OnlineLecture) {
        final lecturesProvider =
            Provider.of<OnlineLecturesProvider>(context, listen: false);

        await lecturesProvider.signIn(_lecture! as OnlineLecture);
      } else {
        final qr =
            await Navigator.pushNamed(context, routes.scanQrScreen) as String?;

        if (qr == null) {
          return;
        }

        final lecturesProvider =
            Provider.of<OfflineLecturesProvider>(context, listen: false);
        await lecturesProvider.signIn(_lecture! as OfflineLecture, qr);
      }

      await _refresh();
    } on HttpError catch (ex) {
      DialogsService.showSnackBar(context, ex.message.capitalize());
    }
  }

  Future<void> _signoff() async {
    try {
      if (T == OnlineLecture) {
        final lecturesProvider =
            Provider.of<OnlineLecturesProvider>(context, listen: false);

        await lecturesProvider.signOff(_lecture! as OnlineLecture);
      } else {
        final qr =
            await Navigator.pushNamed(context, routes.scanQrScreen) as String?;

        if (qr == null) {
          return;
        }

        final lecturesProvider =
            Provider.of<OfflineLecturesProvider>(context, listen: false);
        await lecturesProvider.signOff(_lecture! as OfflineLecture, qr);
      }
      await _refresh();
    } on HttpError catch (ex) {
      DialogsService.showSnackBar(context, ex.message.capitalize());
    }
  }

  Widget _createAttendedStudentListTile(AttendanceRequest req) {
    return ListTile(
      leading: const CircleAvatar(),
      title: Text(req.requestedBy.fullName),
      subtitle: Text(
        'Joined at: ${DateFormat.yMd().add_Hm().format(req.timeRequested)}',
      ),
      onTap: () {},
      tileColor: req.isAccepted
          ? Colors.green.withAlpha(20)
          : _lecture!.isExpired
              ? Colors.red.withAlpha(20)
              : Colors.transparent,
    );
  }

  Future<void> _showOfflineLectureQrCode() async {
    if (_lecture is! OfflineLecture ||
        (_lecture as OfflineLecture).attendanceCode == null) {
      return;
    }

    await DialogsService.showAlertDialog(
      context,
      SizedBox(
        height: 256,
        width: 256,
        child: Center(
          child: QrImage(
            data: (_lecture as OfflineLecture).attendanceCode!,
          ),
        ),
      ),
      title: const Text('Lecture QR Code'),
    );
  }

  Widget? _createFloatingActionButton(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.session!.role == UserRole.student) {
      if (_currentReq == null) {
        return FloatingActionButton.extended(
          onPressed: _signin,
          icon: Icon(T == OfflineLecture
              ? Icons.qr_code_scanner
              : Icons.arrow_forward),
          label: const Text('Sign-in'),
        );
      } else if (_currentReq!.isAccepted) {
        return null;
      } else {
        return FloatingActionButton.extended(
          onPressed: _signoff,
          icon: Icon(
              T == OfflineLecture ? Icons.qr_code_scanner : Icons.arrow_back),
          label: const Text('Sign-off'),
        );
      }
    }

    if (T == OfflineLecture &&
        authProvider.session!.role == UserRole.instructor) {
      return FloatingActionButton(
        onPressed: _showOfflineLectureQrCode,
        child: const Icon(Icons.qr_code),
      );
    }

    return null;
  }

  @override
  void initState() {
    _lecture = widget.lecture;

    _refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final lecturesProvider = Provider.of<CrudProvider<T>>(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    floating: true,
                    expandedHeight: 160.0,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(_lecture!.title),
                          Text(
                            _currentReq != null
                                ? 'Joined at ${DateFormat.yMd().add_Hm().format(_currentReq!.timeRequested)}'
                                : _lecture!.timeString,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: Colors.white60, fontSize: 12),
                          )
                        ],
                      ),
                      collapseMode: CollapseMode.parallax,
                    ),
                    actions: authProvider.session!.role == UserRole.instructor
                        ? <Widget>[
                            if (T == OfflineLecture)
                              IconButton(
                                icon: const Icon(Icons.qr_code),
                                onPressed: _showOfflineLectureQrCode,
                              ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await Navigator.pushNamed(
                                  context,
                                  T == OnlineLecture
                                      ? routes.editOnlineLectureScreen
                                      : routes.editOfflineLectureScreen,
                                  arguments: {
                                    'courseId': _lecture!.courseId,
                                    'lecture': _lecture,
                                  },
                                );

                                setState(() => _lecture =
                                    lecturesProvider.getItem(_lecture!.id));
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final ret =
                                    await DialogsService.showQuestionDialog(
                                  context,
                                  const Text(
                                      'Are you sure you want delete this lecture?'),
                                  title: const Text('Confirm deletion'),
                                );

                                if (ret ?? false) {
                                  try {
                                    await lecturesProvider.delete(_lecture!);
                                    DialogsService.showSnackBar(
                                      context,
                                      'Lecture deleted',
                                    );

                                    Navigator.pop(context);
                                  } on HttpError catch (ex) {
                                    DialogsService.showSnackBar(
                                      context,
                                      ex.message.capitalize(),
                                    );
                                  }
                                }
                              },
                            ),
                          ]
                        : <Widget>[
                            if (T == OfflineLecture)
                              IconButton(
                                icon: const Icon(Icons.qr_code_scanner),
                                onPressed: () {},
                              ),
                          ],
                  ),
                  const SliverToBoxAdapter(
                    child: SectionHeader(
                      title: 'Attending students',
                      padding: EdgeInsets.fromLTRB(18, 18, 18, 8),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext ctx, int i) =>
                          _createAttendedStudentListTile(_currentAttendees[i]),
                      childCount: _currentAttendees.length,
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: _createFloatingActionButton(context),
    );
  }
}
