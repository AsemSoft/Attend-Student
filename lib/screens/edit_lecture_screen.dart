import 'package:attend/models/course.dart';
import 'package:attend/providers/crud_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../extensions/string_extensions.dart';
import '../models/lecture.dart';
import '../models/online_lecture.dart';
import '../services/http_error.dart';
import '../util/dialogs_service.dart';
import '../util/validator.dart';
import '../widgets/datetime_selector_button.dart';
import '../widgets/duration_selector_button.dart';
import '../widgets/large_submit_button.dart';
import '../widgets/section_header.dart';

abstract class EditLectureScreen<T extends Lecture> extends StatefulWidget {
  final int lectureCourseId;
  final T? lecture;

  const EditLectureScreen(
    this.lectureCourseId, {
    Key? key,
    this.lecture,
  }) : super(key: key);

  @override
  State<EditLectureScreen> createState() => _EditLectureScreenState<T>();

  T createModel(
    T? editLecture,
    String selectedTitle,
    DateTime selectedDateTimeStarts,
    Duration selectedDuration,
    Duration selectedAcceptedAttendancePeriod,
    int courseId,
  );
}

class _EditLectureScreenState<T extends Lecture>
    extends State<EditLectureScreen> {
  T? _editLecture;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  DateTime? _selectedDateTimeStarts;
  Duration _selectedDuration = const Duration(minutes: 120);
  Duration _selectedAcceptedAttendancePeriod = const Duration(minutes: 40);

  bool _isLoading = false;

  String get screenTitle {
    if (T == OnlineLecture) {
      return _editLecture == null
          ? 'Add online lecture'
          : 'Edit online lecture';
    }

    return _editLecture == null
        ? 'Add offline lecture'
        : 'Edit offline lecture';
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    //في حال لم يححد وقت او تاريخ
    if (_selectedDateTimeStarts == null) {
      DialogsService.showSnackBar(
        context,
        'Please select the starting date and time',
      );
      return;
    }

    if (_selectedDuration < _selectedAcceptedAttendancePeriod) {
      DialogsService.showSnackBar(
        context,
        'Accepted period must be less than lecture duration',
      );
      return;
    }

    setState(() => _isLoading = true);

    final lecturesProvider = Provider.of<CrudProvider<T>>(
      context,
      listen: false,
    );
    final lecture = widget.createModel(
      _editLecture,
      _titleController.text,
      _selectedDateTimeStarts!,
      _selectedDuration,
      _selectedAcceptedAttendancePeriod,
      widget.lectureCourseId,
    );

    try {
      if (_editLecture == null) {
        // اذا كان محاضره جديده هنا
        await lecturesProvider.add(lecture as T);
      } else {
        // اذا يريد تعديل على المحاضره هنا
        await lecturesProvider.update(lecture as T);
      }

      Navigator.pop(context);
      DialogsService.showSnackBar(context, 'Lectuer saved');
    } on HttpError catch (ex) {
      DialogsService.showSnackBar(context, ex.message.capitalize());
    }

    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    if (widget.lecture != null) {
      _editLecture = widget.lecture as T;
      _titleController.text = _editLecture!.title;
      _selectedDateTimeStarts = _editLecture!.timeStarts;
      _selectedDuration = _editLecture!.duration;
      _selectedAcceptedAttendancePeriod =
          _editLecture!.acceptedAttendancePeriod;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(screenTitle),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: _isLoading ? null : _submit,
                icon: const Icon(Icons.check),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(18),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SectionHeader(
                      title: 'Lecture info',
                    ),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        label: Text('Title'),
                        prefixIcon: Icon(Icons.alternate_email_outlined),
                        filled: true,
                      ),
                      validator: (v) =>
                          Validator.validateNotEmpty(v, 'Lecture title'),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text('Lecture starting date and time'),
                    ),
                    DateTimeSelectorButton(
                      onDateTimeSelected: (dt) => _selectedDateTimeStarts = dt,
                      initialDateTime: _selectedDateTimeStarts,
                      label: 'Tap to select starting date and time',
                    ),
                    const Divider(),
                    const SectionHeader(
                      title: 'Lecture settings',
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Text('Lecture duration'),
                    ),
                    DurationSelectorButton(
                      label: 'Tap to select lecture duration',
                      onDurationSelected: (d) => _selectedDuration = d,
                      initialDuration: _selectedDuration,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text('Accepted attendance period'),
                    ),
                    DurationSelectorButton(
                      label: 'Tap to select lecture accepted period',
                      onDurationSelected: (d) =>
                          _selectedAcceptedAttendancePeriod = d,
                      initialDuration: _selectedAcceptedAttendancePeriod,
                    ),
                    const SizedBox(height: 16),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : LargeSubmitButton(
                            label: 'SAVE',
                            icon: Icons.save_outlined,
                            onPressed: _submit,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();

    super.dispose();
  }
}
