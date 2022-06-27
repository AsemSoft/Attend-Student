// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_lecture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnlineLecture _$OnlineLectureFromJson(Map<String, dynamic> json) =>
    OnlineLecture(
      id: json['id'] as int,
      title: json['title'] as String,
      timeStarts: DateTime.parse(json['timeStarts'] as String),
      duration: Duration(microseconds: json['duration'] as int),
      acceptedAttendancePeriod:
          Duration(microseconds: json['acceptedAttendancePeriod'] as int),
      courseId: json['courseId'] as int,
    );

Map<String, dynamic> _$OnlineLectureToJson(OnlineLecture instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'timeStarts': instance.timeStarts.toIso8601String(),
      'duration': instance.duration.inMicroseconds,
      'acceptedAttendancePeriod':
          instance.acceptedAttendancePeriod.inMicroseconds,
      'courseId': instance.courseId,
    };
