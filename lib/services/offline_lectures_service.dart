import 'package:attend/models/attendance_request.dart';

import '../models/offline_lecture.dart';
import '../services/http_context.dart';
import '../services/crud_service.dart';

class OfflineLecturesService extends CrudService<OfflineLecture> {
  OfflineLecturesService(HttpContext ctx, String basePath)
      : super(ctx, basePath);

  Future<List<OfflineLecture>> getMyLectures() async {
    final List json = await httpContext.get('$basePath/my-lectures');
    return json.map((i) => parseModel(i)).toList();
  }

  Future<void> signIn(int lectureId, String code) async {
    await httpContext.get('$basePath/$lectureId/sign-in/$code');
  }

  Future<void> signOff(int lectureId, String code) async {
    await httpContext.delete('$basePath/$lectureId/sign-off/$code');
  }

  Future<List<AttendanceRequest>> getAttendanceRequests(int lectureId) async {
    final List json =
        await httpContext.get('$basePath/$lectureId/attendance-requests');
    return json.map((i) => AttendanceRequest.fromJson(i)).toList();
  }

  @override
  OfflineLecture parseModel(Map<String, dynamic> json) {
    return OfflineLecture.fromJson(json);
  }

  @override
  Map<String, dynamic> serializeModel(OfflineLecture model) {
    return model.toJson();
  }
}
