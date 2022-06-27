import 'package:attend/providers/users_provider.dart';
import 'package:attend/widgets/add_reference_book_form.dart';
import 'package:attend/widgets/course_students_list.dart';
import 'package:attend/widgets/reference_books_list.dart';
import 'package:attend/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../extensions/string_extensions.dart';
import '../models/course.dart';
import '../models/session_user.dart';
import '../models/user.dart';
import '../providers/courses_provider.dart';
import '../services/http_error.dart';
import '../util/dialogs_service.dart';
import '../util/validator.dart';
import '../widgets/large_submit_button.dart';
import '../widgets/section_header.dart';
import '../widgets/user_selector.dart';

class EditCourseScreen extends StatefulWidget {
  const EditCourseScreen({Key? key}) : super(key: key);

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  Course? _editCourse;
  User? _selectedInstructor;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    // في حال لم يحدد نوع المعلم للكورس
    if (_selectedInstructor == null) {
      DialogsService.showSnackBar(
          context, 'Please select an instructor for the course');
      return;
    }

    setState(() => _isLoading = true);

    final coursesProvider =
        Provider.of<CoursesProvider>(context, listen: false);
    //  courseبيقوم بخزن البيانات الى الموديل  كورس
    final course = Course(
        id: _editCourse?.id ?? 0,
        title: _titleController.text,
        description: _descriptionController.text,
        instructorId: _selectedInstructor!.id,
        message: _editCourse?.message);

    try {
      if (_editCourse == null) {
        //في حال الـ course جديد سيتم التعامل معه بهذا السطر
        await coursesProvider.add(course);
      } else {
        //في حال الـ course جديد موجود مسبقاً سيتم التعامل معه بهذ السطر

        await coursesProvider.update(course);
      }

      Navigator.pop(context);
      DialogsService.showSnackBar(context, 'Course saved');
    } on HttpError catch (ex) {
      DialogsService.showSnackBar(context, ex.message.capitalize());
    }

    setState(() => _isLoading = false);
  }

  Future<void> _addReferenceBook() async {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      builder: (context) => SingleChildScrollView(
        child: AddReferenceBookForm(
          courseId: _editCourse!.id,
          onBookAdded: (book) {
            DialogsService.showSnackBar(context, 'Reference book saved');
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Future<void> _enrollStudent() async {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final coursesProvider =
        Provider.of<CoursesProvider>(context, listen: false);

    final ret = await DialogsService.showFutureChoiceDialog(
      context,
      usersProvider.loadByCategory(UserRole.student),
      (i, _) => UserTile((i as User)),
      title: const Text('Choose a student to enroll'),
    );

    if (ret != null) {
      try {
        await coursesProvider.enrollStudent(_editCourse!.id, ret);
        DialogsService.showSnackBar(
          context,
          'Student `${ret.fullName}\' was added to the course',
        );
      } on HttpError catch (ex) {
        DialogsService.showSnackBar(context, ex.message.capitalize());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final coursesProvider =
        Provider.of<CoursesProvider>(context, listen: false);

    final id = ModalRoute.of(context)!.settings.arguments as int?;

    if (id != null) {
      _editCourse = coursesProvider.getItem(id);
      _titleController.text = _editCourse!.title;
      _descriptionController.text = _editCourse!.description ?? '';
      _selectedInstructor = usersProvider.getItem(_editCourse!.instructorId);
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                  _editCourse == null ? 'Add a new course' : 'Edit course'),
            ),
            actions: <Widget>[
              if (_editCourse != null) ...[
                IconButton(
                  onPressed: _addReferenceBook,
                  icon: const Icon(Icons.library_add_outlined),
                ),
                IconButton(
                  onPressed: _enrollStudent,
                  icon: const Icon(Icons.person_add_alt_1_outlined),
                ),
              ],
              IconButton(
                onPressed: _isLoading ? null : _submit,
                icon: const Icon(Icons.check),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(18),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        const SectionHeader(
                          title: 'Course info',
                        ),
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                            prefixIcon: Icon(Icons.book_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) =>
                              Validator.validateNotEmpty(v, 'Title'),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            label: Text('Description'),
                            prefixIcon: Icon(Icons.more_horiz_outlined),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SectionHeader(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              title: 'Course instructor',
            ),
          ),
          SliverToBoxAdapter(
            child: UserSelector(
              initUser: _selectedInstructor,
              role: UserRole.instructor,
              onUserSelected: (u) {
                _selectedInstructor = u;
              },
              prompt: 'Select course instructor',
            ),
          ),
          if (_editCourse != null) ...[
            SliverToBoxAdapter(
              child: SectionHeader(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
                title: 'Course reference books',
                actions: <Widget>[
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: _addReferenceBook,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              sliver: SliverToBoxAdapter(
                child: ReferenceBooksList(
                  courseId: _editCourse!.id,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SectionHeader(
                padding: EdgeInsets.fromLTRB(18, 18, 18, 8),
                title: 'Course enrolled students',
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 64),
              sliver: SliverToBoxAdapter(
                child: CourseStudentsList(courseId: _editCourse!.id),
              ),
            )
          ],
          if (_editCourse == null)
            SliverToBoxAdapter(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : LargeSubmitButton(
                      margin: const EdgeInsets.all(18),
                      label: 'SAVE',
                      icon: Icons.save_outlined,
                      onPressed: _submit,
                    ),
            )
        ],
      ),
      floatingActionButton: _editCourse == null
          ? null
          : FloatingActionButton.extended(
              onPressed: _enrollStudent,
              label: const Text('Enroll Students'),
              icon: const Icon(Icons.person_add_alt),
            ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }
}
