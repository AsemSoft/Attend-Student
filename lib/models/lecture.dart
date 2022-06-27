import 'package:intl/intl.dart';

import '../models/base_model.dart';

abstract class Lecture extends BaseModel {
  final String title;
  final DateTime timeStarts;
  final Duration duration;
  final Duration acceptedAttendancePeriod;
  final int courseId;

  const Lecture({
    required int id,
    required this.title,
    required this.timeStarts,
    required this.duration,
    required this.acceptedAttendancePeriod,
    required this.courseId,
  }) : super(id);

  bool get isExpired => DateTime.now().isAfter(timeStarts.add(duration));
  
  String get timeString {
    final now = DateTime.now();

    if (now.isBefore(timeStarts)) {
      return DateFormat.yMd().add_Hm().format(timeStarts);
    } else if (now.isAfter(timeStarts) &&
        now.isBefore(timeStarts.add(duration))) {
      final finishTime = timeStarts.add(duration);
      final left = finishTime.difference(now);
      return '${left.inMinutes} mins left';
    } else {
      return 'Expired';
    }
  }
}
