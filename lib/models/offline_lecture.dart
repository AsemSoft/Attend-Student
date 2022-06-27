import 'package:json_annotation/json_annotation.dart';

import '../models/lecture.dart';

part 'offline_lecture.g.dart';

@JsonSerializable()
class OfflineLecture extends Lecture {
  final String? attendanceCode;

  const OfflineLecture({
    required int id,
    required String title,
    required DateTime timeStarts,
    required Duration duration,
    required Duration acceptedAttendancePeriod,
    required int courseId,
    this.attendanceCode,
  }) : super(
          id: id,
          title: title,
          timeStarts: timeStarts,
          duration: duration,
          acceptedAttendancePeriod: acceptedAttendancePeriod,
          courseId: courseId,
        );

  factory OfflineLecture.fromJson(Map<String, dynamic> json) =>
      _$OfflineLectureFromJson(json);
  Map<String, dynamic> toJson() => _$OfflineLectureToJson(this);
}
