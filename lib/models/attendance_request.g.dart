// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceRequest _$AttendanceRequestFromJson(Map<String, dynamic> json) =>
    AttendanceRequest(
      id: json['id'] as int,
      timeRequested: DateTime.parse(json['timeRequested'] as String),
      requestedBy: User.fromJson(json['requestedBy'] as Map<String, dynamic>),
      isAccepted: json['isAccepted'] as bool,
    );

Map<String, dynamic> _$AttendanceRequestToJson(AttendanceRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timeRequested': instance.timeRequested.toIso8601String(),
      'requestedBy': instance.requestedBy,
      'isAccepted': instance.isAccepted,
    };
