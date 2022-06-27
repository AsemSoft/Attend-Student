import 'package:attend/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'course.g.dart';

@JsonSerializable()
class Course extends BaseModel {
  final String title;
  final String? description;
  final int instructorId;
  String? message;

  String get header {
    if (description != null) {
      return '$title - $description';
    }
    
    return title;
  }
  
  Course({
    required int id,
    required this.title,
    required this.instructorId,
    this.description,
    this.message,
  }) : super(id);

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);
  Map<String, dynamic> toJson() => _$CourseToJson(this);
}
