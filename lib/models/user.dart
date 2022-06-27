import 'package:json_annotation/json_annotation.dart';

import '../models/base_model.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends BaseModel {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final bool isEnabled;

  String? role;
  String? password;

  String get fullName => '$firstName $lastName';

  User({
    required int id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isEnabled,
    this.role,
    this.password,
  }) : super(id);
  
  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}