import 'package:attend/models/base_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reference_book.g.dart';

@JsonSerializable()
class ReferenceBook extends BaseModel {
  final String title;
  final String? author;
  final String? publisher;
  final DateTime? publishedAt;

  const ReferenceBook({
    required int id,
    required this.title,
    this.author,
    this.publisher,
    this.publishedAt,
  }) : super(id);

  factory ReferenceBook.fromJson(Map<String, dynamic> json) => _$ReferenceBookFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceBookToJson(this);
}
