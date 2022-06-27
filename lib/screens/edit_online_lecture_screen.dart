import 'package:flutter/material.dart';

import '../models/online_lecture.dart';
import '../screens/edit_lecture_screen.dart';

class EditOnlineLectureScreen extends EditLectureScreen<OnlineLecture> {
  const EditOnlineLectureScreen(int lectureCourseId,
      {Key? key, OnlineLecture? lecture})
      : super(lectureCourseId, key: key, lecture: lecture);

  @override
  OnlineLecture createModel(
    OnlineLecture? editLecture,
    String selectedTitle,
    DateTime selectedDateTimeStarts,
    Duration selectedDuration,
    Duration selectedAcceptedAttendancePeriod,
    int courseId,
  ) {
    return OnlineLecture(
      id: editLecture?.id ?? 0,
      title: selectedTitle,
      timeStarts: selectedDateTimeStarts,
      duration: selectedDuration,
      acceptedAttendancePeriod: selectedAcceptedAttendancePeriod,
      courseId: courseId,
    );
  }
}
