import 'package:attend/models/course.dart';
import 'package:attend/providers/courses_provider.dart';
import 'package:attend/util/dialogs_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes.dart' as routes;
import '../widgets/search_text_field.dart';

class CoursesManagmentPage extends StatefulWidget {
  const CoursesManagmentPage({Key? key}) : super(key: key);

  @override
  State<CoursesManagmentPage> createState() => _CoursesManagmentPageState();
}

class _CoursesManagmentPageState extends State<CoursesManagmentPage> {
  bool _isInit = true;
  bool _isLoading = false;

  Future<void> _refresh() async {
    final coursesProvider =
        Provider.of<CoursesProvider>(context, listen: false);
    await coursesProvider.refresh();
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
                  title: const Text('Courses'),
                  actions: <Widget>[
                    IconButton(
                      onPressed: () => {},
                      icon: const Icon(Icons.filter_list),
                    ),
                    IconButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, routes.editCourseScreen),
                      icon: const Icon(Icons.add),
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
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  sliver: SliverGrid.extent(
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      maxCrossAxisExtent: 256,
                      childAspectRatio: 1,
                      children: coursesProvider.items
                          .map((c) =>
                              _createCoureseCard(context, coursesProvider, c))
                          .toList()),
                )
              ],
            ),
    );
  }
}

Card _createCoureseCard(
    BuildContext context, CoursesProvider coursesProvider, Course course) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: InkWell(
      onTap: () {},
      child: Ink(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.indigo,
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      right: 0,
                      //left: 0,
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, routes.editCourseScreen,
                                  arguments: course.id);
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              final ret =
                                  await DialogsService.showQuestionDialog(
                                          context,
                                          Text(
                                            'Are you sure you want to delete course `${course.title}\'?',
                                          ),
                                          title:
                                              const Text('Confirm deletion')) ??
                                      false;

                              if (ret) {
                                // في حال عمل موافق على الحذف
                                coursesProvider.delete(course);
                                DialogsService.showSnackBar(
                                    context, 'Course deleted');
                              }
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, .6),
                      child: FittedBox(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            course.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 48,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (course.description != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  course.description!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
