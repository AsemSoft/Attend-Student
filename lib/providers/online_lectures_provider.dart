import 'package:attend/models/attendance_request.dart';
import 'package:attend/models/online_lecture.dart';
import 'package:attend/services/online_lectures_service.dart';

import 'crud_provider.dart';
import '../services/crud_service.dart';

class OnlineLecturesProvider extends CrudProvider<OnlineLecture> {
  final List<OnlineLecture> _myLectures = [];

  OnlineLecturesProvider(CrudService<OnlineLecture> service) : super(service);

  List<OnlineLecture> get myLectures => _myLectures;

  Future<void> refreshMyLectures() async {
    _myLectures.clear();
    _myLectures.addAll(
      await (service as OnlineLecturesService).getMyLectures(),
    );

    notifyListeners();
  }

  Future<List<AttendanceRequest>> getAttendanceRequests(int lectureId) async {
    return await (service as OnlineLecturesService)
        .getAttendanceRequests(lectureId);
  }

  Future<void> signIn(OnlineLecture lecture) async {
    await (service as OnlineLecturesService).signIn(lecture.id);

    notifyListeners();
  }

  Future<void> signOff(OnlineLecture lecture) async {
    await (service as OnlineLecturesService).signOff(lecture.id);

    notifyListeners();
  }

  @override
  Future<void> add(OnlineLecture item) async {
    final retItem = await service.add(item);

    items.add(retItem);
    _myLectures.add(retItem);

    notifyListeners();
  }

  @override
  Future<void> delete(OnlineLecture item) async {
    await service.delete(item);
    items.remove(item);

    if (_myLectures.contains(item)) {
      _myLectures.remove(item);
    }

    notifyListeners();
  }
}
