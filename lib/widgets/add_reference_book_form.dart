import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/reference_book.dart';
import '../providers/courses_provider.dart';
import '../services/http_error.dart';
import '../util/dialogs_service.dart';
import '../util/validator.dart';
import '../extensions/string_extensions.dart';
import '../widgets/large_submit_button.dart';
import '../widgets/section_header.dart';
import 'date_selector_button.dart';

class AddReferenceBookForm extends StatefulWidget {
  final int courseId;
  final void Function(ReferenceBook) onBookAdded;

  const AddReferenceBookForm({
    Key? key,
    required this.courseId,
    required this.onBookAdded,
  }) : super(key: key);

  @override
  State<AddReferenceBookForm> createState() => _AddReferenceBookFormState();
}

class _AddReferenceBookFormState extends State<AddReferenceBookForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _publisherController = TextEditingController();

  DateTime? _selectedPublishDate;
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() => _isLoading = true);

    final coursesProvider =
        Provider.of<CoursesProvider>(context, listen: false);
    final book = ReferenceBook(
      id: 0,
      title: _titleController.text,
      publisher: _publisherController.text.isNotEmpty
          ? _publisherController.text
          : null,
      publishedAt: _selectedPublishDate,
    );

    try {
      await coursesProvider.addReferenceBook(widget.courseId, book);
      widget.onBookAdded(book);
    } on HttpError catch (ex) {
      DialogsService.showSnackBar(context, ex.message.capitalize());
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).viewInsets.copyWith(left: 18, right: 18),
      child: Column(
        children: <Widget>[
          const SectionHeader(
            title: 'Add a reference book',
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Book title',
                    filled: true,
                    prefixIcon: Icon(Icons.book_rounded),
                    border: UnderlineInputBorder(),
                  ),
                  validator: (v) => Validator.validateNotEmpty(v, 'Book title'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _publisherController,
                  decoration: const InputDecoration(
                    hintText: 'Publisher',
                    filled: true,
                    prefixIcon: Icon(Icons.library_books),
                    border: UnderlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          DateSelectorButton(
            onDateSelected: (dt) => _selectedPublishDate = dt,
            label: 'Tap to select publish date',
          ),
          const SizedBox(height: 18),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : LargeSubmitButton(
                  label: 'SAVE',
                  icon: Icons.save_outlined,
                  onPressed: _submit,
                ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
