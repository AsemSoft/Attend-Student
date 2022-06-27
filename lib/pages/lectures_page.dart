import 'package:attend/models/offline_lecture.dart';
import 'package:attend/models/online_lecture.dart';
import 'package:attend/providers/offline_lectures_provider.dart';
import 'package:attend/widgets/search_text_field.dart';

import '../extensions/string_extensions.dart';
import 'package:attend/providers/courses_provider.dart';
import 'package:attend/providers/online_lectures_provider.dart';
import 'package:attend/services/http_error.dart';
import 'package:attend/util/dialogs_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/lecture_item.dart';

class LecturesPage extends StatefulWidget {
  const LecturesPage({Key? key}) : super(key: key);

  @override
  State<LecturesPage> createState() => _LecturesPageState();
}

class _LecturesPageState extends State<LecturesPage> {
  bool _isInit = true;
  bool _isLoading = false;

  Future<void> _refresh() async {
    final onlineLecturesProvider =
        Provider.of<OnlineLecturesProvider>(context, listen: false);
    final offlineLecturesProvider =
        Provider.of<OfflineLecturesProvider>(context, listen: false);

    try {
      await onlineLecturesProvider.refreshMyLectures();
      await offlineLecturesProvider.refreshMyLectures();
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
    final onlineLecturesProvider = Provider.of<OnlineLecturesProvider>(context);
    final offlineLecturesProvider =
        Provider.of<OfflineLecturesProvider>(context);

    return RefreshIndicator(
      onRefresh: _refresh,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  floating: true,
                  title: const Text('My Lectures'),
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
                  sliver: SliverGrid.extent(
                    maxCrossAxisExtent: 328,
                    childAspectRatio: 2 / 1.4,
                    children: [
                      ...onlineLecturesProvider.myLectures,
                      ...offlineLecturesProvider.myLectures
                    ]
                        .map(
                          (e) => e is OnlineLecture
                              ? LectureItem<OnlineLecture>(e)
                              : LectureItem<OfflineLecture>(e as OfflineLecture),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
    );
  }
}
