// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_lecture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfflineLecture _$OfflineLectureFromJson(Map<String, dynamic> json) =>
    OfflineLecture(
      id: json['id'] as int,
      title: json['title'] as String,
      timeStarts: DateTime.parse(json['timeStarts'] as String),
      duration: Duration(microseconds: json['duration'] as int),
      acceptedAttendancePeriod:
          Duration(microseconds: json['acceptedAttendancePeriod'] as int),
      courseId: json['courseId'] as int,
      attendanceCode: json['attendanceCode'] as String?,
    );

Map<String, dynamic> _$OfflineLectureToJson(OfflineLecture instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'timeStarts': instance.timeStarts.toIso8601String(),
      'duration': instance.duration.inMicroseconds,
      'acceptedAttendancePeriod':
          instance.acceptedAttendancePeriod.inMicroseconds,
      'courseId': instance.courseId,
      'attendanceCode': instance.attendanceCode,
    };
