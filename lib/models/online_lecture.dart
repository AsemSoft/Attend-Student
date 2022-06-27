import 'package:json_annotation/json_annotation.dart';

import '../models/lecture.dart';

part 'online_lecture.g.dart';

@JsonSerializable()
class OnlineLecture extends Lecture {
  OnlineLecture({
    required int id,
    required String title,
    required DateTime timeStarts,
    required Duration duration,
    required Duration acceptedAttendancePeriod,
    required int courseId,
  }) : super(
          id: id,
          title: title,
          timeStarts: timeStarts,
          duration: duration,
          acceptedAttendancePeriod: acceptedAttendancePeriod,
          courseId: courseId,
        );

  factory OnlineLecture.fromJson(Map<String, dynamic> json) =>
      _$OnlineLectureFromJson(json);
  Map<String, dynamic> toJson() => _$OnlineLectureToJson(this);
}
