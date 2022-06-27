// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReferenceBook _$ReferenceBookFromJson(Map<String, dynamic> json) =>
    ReferenceBook(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['author'] as String?,
      publisher: json['publisher'] as String?,
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
    );

Map<String, dynamic> _$ReferenceBookToJson(ReferenceBook instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'publisher': instance.publisher,
      'publishedAt': instance.publishedAt?.toIso8601String(),
    };
