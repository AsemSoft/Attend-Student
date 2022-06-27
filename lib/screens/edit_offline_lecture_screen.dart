import 'package:flutter/material.dart';

import '../models/offline_lecture.dart';
import '../screens/edit_lecture_screen.dart';

class EditOfflineLectureScreen extends EditLectureScreen<OfflineLecture> {
  const EditOfflineLectureScreen(int lectureCourseId,
      {Key? key, OfflineLecture? lecture})
      : super(lectureCourseId, key: key, lecture: lecture);

  @override
  OfflineLecture createModel(
    OfflineLecture? editLecture,
    String selectedTitle,
    DateTime selectedDateTimeStarts,
    Duration selectedDuration,
    Duration selectedAcceptedAttendancePeriod,
    int courseId,
  ) {
    return OfflineLecture(
      id: editLecture?.id ?? 0,
      title: selectedTitle,
      timeStarts: selectedDateTimeStarts,
      duration: selectedDuration,
      acceptedAttendancePeriod: selectedAcceptedAttendancePeriod,
      courseId: courseId,
    );
  }
}
