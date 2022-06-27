import 'package:attend/models/attendance_request.dart';

import '../models/online_lecture.dart';
import '../services/http_context.dart';
import '../services/crud_service.dart';

class OnlineLecturesService extends CrudService<OnlineLecture> {
  OnlineLecturesService(HttpContext ctx, String basePath)
      : super(ctx, basePath);

  Future<List<OnlineLecture>> getMyLectures() async {
    final List json = await httpContext.get('$basePath/my-lectures');
    return json.map((i) => parseModel(i)).toList();
  }

  Future<void> signIn(int lectureId) async {
    await httpContext.get('$basePath/$lectureId/sign-in');
  }

  Future<void> signOff(int lectureId) async {
    await httpContext.delete('$basePath/$lectureId/sign-off');
  }

  Future<List<AttendanceRequest>> getAttendanceRequests(int lectureId) async {
    final List json =
        await httpContext.get('$basePath/$lectureId/attendance-requests');
    return json.map((i) => AttendanceRequest.fromJson(i)).toList();
  }

  @override
  OnlineLecture parseModel(Map<String, dynamic> json) {
    return OnlineLecture.fromJson(json);
  }

  @override
  Map<String, dynamic> serializeModel(OnlineLecture model) {
    return model.toJson();
  }
}
