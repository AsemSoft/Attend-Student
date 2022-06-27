import '../models/user.dart';
import '../services/courses_service.dart';
import '../models/reference_book.dart';
import 'crud_provider.dart';
import '../services/crud_service.dart';
import '../models/course.dart';

class CoursesProvider extends CrudProvider<Course> {
  final List<Course> _myCourses = [];

  final Map<int, List<Course>> _userCoursesCache = {};
  final Map<int, List<ReferenceBook>> _referenceBooksCache = {};
  final Map<int, List<User>> _enrolledStudentsCache = {};

  CoursesProvider(CrudService<Course> service) : super(service);

  List<Course> get myCourses => _myCourses;

  Future<List<Course>> getCoursesForUser(int userId) async {
    if (_userCoursesCache.containsKey(userId)) {
      return _userCoursesCache[userId]!;
    }

    final courses = await (service as CoursesSerivce).getForUser(userId);
    _userCoursesCache[userId] = courses;

    notifyListeners();
    return courses;
  }

  Future<void> refreshMyCourses() async {
    _myCourses.clear();
    _myCourses.addAll(await (service as CoursesSerivce).getMyCourses());

    notifyListeners();
  }

  Future<List<ReferenceBook>> getReferenceBooks(int courseId) async {
    if (_referenceBooksCache.containsKey(courseId)) {
      return _referenceBooksCache[courseId]!;
    }

    final books = await (service as CoursesSerivce).getReferenceBooks(courseId);
    _referenceBooksCache[courseId] = books;

    notifyListeners();
    return books;
  }

    // عملية اضافة مرجع
  Future<void> addReferenceBook(int courseId, ReferenceBook book) async {
    final ret = await (service as CoursesSerivce).addReferenceBook(
      courseId,
      book,
    );

    if (_referenceBooksCache.containsKey(courseId)) {
      _referenceBooksCache[courseId]!.add(ret);
    }

    notifyListeners();
  }

  Future<void> deleteReferenceBook(int courseId, ReferenceBook book) async {
    await (service as CoursesSerivce).deleteReferenceBook(courseId, book);

    if (_referenceBooksCache.containsKey(courseId)) {
      _referenceBooksCache[courseId]!.remove(book);
      notifyListeners();
    }
  }

  Future<List<User>> getEnrolledStudents(int courseId) async {
    if (_enrolledStudentsCache.containsKey(courseId)) {
      return _enrolledStudentsCache[courseId]!;
    }

    final students = await (service as CoursesSerivce).getEnrolledStudents(
      courseId,
    );
    _enrolledStudentsCache[courseId] = students;

    notifyListeners();
    return students;
  }

  Future<void> enrollStudent(int courseId, User student) async {
    await (service as CoursesSerivce).enrollStudent(courseId, student.id);

    if (_enrolledStudentsCache.containsKey(courseId)) {
      _enrolledStudentsCache[courseId]!.add(student);
    }

    notifyListeners();
  }

  Future<void> unenrollStudent(int courseId, User student) async {
    await (service as CoursesSerivce).unenrollStudent(courseId, student.id);

    if (_enrolledStudentsCache.containsKey(courseId)) {
      _enrolledStudentsCache[courseId]!.remove(student);
      notifyListeners();
    }
  }

  Future<void> setMessage(int courseId, String message) async {
    await (service as CoursesSerivce).setMessage(courseId, message);
  }

  Future<void> removeMessage(int courseId) async {
    await (service as CoursesSerivce).removeMessage(courseId);
  }

  Future<List<String>> getMessages(int studentId) async {
    return await (service as CoursesSerivce).getMessages(studentId);
  }

  @override
  Future<Course> loadItem(int id) async {
    final idx = _myCourses.indexWhere((i) => i.id == id);

    if (idx < 0) {
      return await super.loadItem(id);
    }

    return _myCourses.firstWhere((i) => i.id == id);
  }

  @override
  Course getItem(int id) {
    final idx = _myCourses.indexWhere((i) => i.id == id);

    if (idx < 0) {
      return super.getItem(id);
    }

    return _myCourses.firstWhere((i) => i.id == id);
  }
}
