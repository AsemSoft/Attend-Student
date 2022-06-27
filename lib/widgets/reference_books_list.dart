import 'package:attend/util/dialogs_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/reference_book.dart';
import '../providers/courses_provider.dart';

class ReferenceBooksList extends StatefulWidget {
  final int courseId;

  const ReferenceBooksList({
    Key? key,
    required this.courseId,
  }) : super(key: key);

  @override
  State<ReferenceBooksList> createState() => _ReferenceBooksListState();
}

class _ReferenceBooksListState extends State<ReferenceBooksList> {
  bool _isStarted = false;

  @override
  Widget build(BuildContext context) {
    final coursesProvider = Provider.of<CoursesProvider>(context);

    return !_isStarted
        ? OutlinedButton(
          onPressed: () => setState(() => _isStarted = true),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Load reference books'),
                  SizedBox(width: 18),
                  Icon(Icons.more_horiz),
                ],
              ),
          ),
        )
        : FutureBuilder<List<ReferenceBook>>(
            future: coursesProvider.getReferenceBooks(widget.courseId),
            builder: (ctx, snapshot) {
              if (snapshot.hasError) {
                return const Text('Could not load items');
              } else if (snapshot.hasData) {
                return ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (ctx, i) => const Divider(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (ctx, i) {
                    final r = snapshot.data![i];
                    return ListTile(
                      onTap: () {},
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      leading: const Icon(Icons.book_outlined),
                      title: Text(r.title),
                      subtitle: Text(
                        'Published by ${r.publisher ?? "N/A"} at ${r.publishedAt != null ? DateFormat.yMd().format(r.publishedAt!) : "N/A"}',
                      ),
                      trailing: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.clear),
                        color: Colors.red,
                        onPressed: () async {
                          final ret = await DialogsService.showQuestionDialog(
                            context,
                            Text(
                              'Are you sure you want to delete book `${r.title}\'?',
                            ),
                            title: const Text('Confirm deletion'),
                          );

                          if (ret ?? false) {
                            await coursesProvider.deleteReferenceBook(
                              widget.courseId,
                              r,
                            );

                            DialogsService.showSnackBar(
                              context,
                              'Reference book deleted',
                            );
                          }
                        },
                      ),
                    );
                  },
                );
              } else {
                return const SizedBox(
                  height: 64,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            });
  }
}
