import 'package:attend/models/attendance_request.dart';
import 'package:attend/models/offline_lecture.dart';
import 'package:attend/services/offline_lectures_service.dart';

import 'crud_provider.dart';
import '../services/crud_service.dart';

class OfflineLecturesProvider extends CrudProvider<OfflineLecture> {
  final List<OfflineLecture> _myLectures = [];

  OfflineLecturesProvider(CrudService<OfflineLecture> service) : super(service);

  List<OfflineLecture> get myLectures => _myLectures;

  Future<void> refreshMyLectures() async {
    _myLectures.clear();
    _myLectures.addAll(
      await (service as OfflineLecturesService).getMyLectures(),
    );

    notifyListeners();
  }

  Future<List<AttendanceRequest>> getAttendanceRequests(int lectureId) async {
    return await (service as OfflineLecturesService)
        .getAttendanceRequests(lectureId);
  }

  Future<void> signIn(OfflineLecture lecture, String code) async {
    await (service as OfflineLecturesService).signIn(lecture.id, code);

    notifyListeners();
  }

  Future<void> signOff(OfflineLecture lecture, String code) async {
    await (service as OfflineLecturesService).signOff(lecture.id, code);

    notifyListeners();
  }

  @override
  Future<void> add(OfflineLecture item) async {
    final retItem = await service.add(item);

    items.add(retItem);
    _myLectures.add(retItem);

    notifyListeners();
  }

  @override
  Future<void> delete(OfflineLecture item) async {
    await service.delete(item);
    items.remove(item);

    if (_myLectures.contains(item)) {
      _myLectures.remove(item);
    }

    notifyListeners();
  }
}
