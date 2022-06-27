import 'package:attend/models/user.dart';

import '../services/crud_service.dart';
import '../services/http_context.dart';
import '../models/course.dart';
import '../models/reference_book.dart';

class CoursesSerivce extends CrudService<Course> {
  CoursesSerivce(HttpContext ctx, String basePath) : super(ctx, basePath);

  Future<List<ReferenceBook>> getReferenceBooks(int courseId) async {
    final List json = await httpContext.get(
      '$basePath/$courseId/reference-books',
    );

    return json.map((r) => ReferenceBook.fromJson(r)).toList();
  }

  Future<List<Course>> getForUser(int userId) async {
    final List json = await httpContext.get('$basePath/for/$userId');

    return json.map((i) => parseModel(i)).toList();
  }

  Future<List<Course>> getMyCourses() async {
    final List json = await httpContext.get('$basePath/my-courses');

    return json.map((i) => parseModel(i)).toList();
  }
    // عملية اضافة مرجع كتاب
  Future<ReferenceBook> addReferenceBook(
      int courseId, ReferenceBook book) async {
    final json =
        await httpContext.post('$basePath/$courseId/reference-books', book);
    return ReferenceBook.fromJson(json);
  }

  Future<void> deleteReferenceBook(int courseId, ReferenceBook book) async {
    await httpContext.delete(
      '$basePath/$courseId/reference-books/${book.id}',
    );
  }

  Future<List<User>> getEnrolledStudents(int courseId) async {
    final List json = await httpContext.get(
      '$basePath/$courseId/enrolled-students',
    );

    return json.map((r) => User.fromJson(r)).toList();
  }

  Future<void> enrollStudent(int courseId, int studentId) async {
    await httpContext.post(
      '$basePath/$courseId/enrolled-students/$studentId',
      null,
    );
  }

  Future<void> unenrollStudent(int courseId, int studentId) async {
    await httpContext.delete(
      '$basePath/$courseId/enrolled-students/$studentId',
    );
  }

  Future<void> setMessage(int courseId, String message) async {
    await httpContext.get(
      '$basePath/$courseId/message',
      queryParameters: {'message': message},
    );
  }

  Future<void> removeMessage(int courseId) async {
    await httpContext.delete(
      '$basePath/$courseId/message',
    );
  }

  Future<List<String>> getMessages(int studentId) async {
    final List ret = await httpContext.get(
      '$basePath/messages-for/$studentId',
    );

    return ret.map((e) => e.toString()).toList();
  }

  @override
  Course parseModel(Map<String, dynamic> json) {
    return Course.fromJson(json);
  }

  @override
  Map<String, dynamic> serializeModel(Course model) {
    return model.toJson();
  }
}
