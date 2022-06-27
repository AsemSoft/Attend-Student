import 'package:attend/models/base_model.dart';
import 'package:attend/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attendance_request.g.dart';

@JsonSerializable()
class AttendanceRequest extends BaseModel {
  final DateTime timeRequested;
  final User requestedBy;
  final bool isAccepted;

  AttendanceRequest({
    required int id,
    required this.timeRequested,
    required this.requestedBy,
    required this.isAccepted,
  }) : super(id);

  factory AttendanceRequest.fromJson(Map<String, dynamic> json) => _$AttendanceRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AttendanceRequestToJson(this);
}
