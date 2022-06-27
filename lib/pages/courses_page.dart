import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/auth_provider.dart';
import '../providers/courses_provider.dart';
import '../services/http_error.dart';
import '../util/dialogs_service.dart';
import '../widgets/search_text_field.dart';
import '../extensions/string_extensions.dart';
import '../widgets/course_tile.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  bool _isInit = true;
  bool _isLoading = false;

  Future<void> _refresh() async {
    final coursesProvider =
        Provider.of<CoursesProvider>(context, listen: false);

    try {
      return await coursesProvider.refreshMyCourses();
    } on HttpError catch (ex) {
      DialogsService.showSnackBar(context, ex.message.capitalize());
    }
  }

  @override
  void initState() {
    if (_isInit) {
      setState(() => _isLoading = true);
      _refresh().then((_) => setState(() => _isLoading = _isInit = false));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final coursesProvider = Provider.of<CoursesProvider>(context);

    return RefreshIndicator(
      onRefresh: _refresh,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  floating: true,
                  title: const Text('My Courses'),
                  actions: <Widget>[
                    IconButton(
                      onPressed: _refresh,
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: SearchTextField(),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      coursesProvider.myCourses
                          .map((c) => CourseTile(c))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
