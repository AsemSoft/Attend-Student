import 'package:attend/util/dialogs_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes.dart' as routes;
import '../models/user.dart';
import '../widgets/search_text_field.dart';
import '../providers/users_provider.dart';

class UsersManagmentPage extends StatefulWidget {
  const UsersManagmentPage({Key? key}) : super(key: key);

  @override
  State<UsersManagmentPage> createState() => _UsersManagmentPageState();
}

class _UsersManagmentPageState extends State<UsersManagmentPage> {
  bool _isInit = true;
  bool _isLoading = false;

  // هذا الداله تعمل عملية تحديث للصفحة
  Future<void> _refresh() async {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    await usersProvider.refresh();
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
    final usersProvider = Provider.of<UsersProvider>(context);

    return RefreshIndicator(
      // هذه الداله بتعمل على تحديث اي تيغير بيحصل في هذه الصفحه مثل اذا اضيف مستخدم جديد
      onRefresh: _refresh,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: <Widget>[
                // SliverAppBar
                /*نفس ويجت الـ
                    AppBar
                  لكن مع خصائص اضفية فقط*/
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  floating: true,
                  title: const Text('Users'),
                  actions: <Widget>[
                    IconButton(
                      onPressed: () => {},
                      icon: const Icon(Icons.filter_list),
                    ),
                    IconButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, routes.editUserScreen),
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
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => _createUserTile(
                      context,
                      usersProvider,
                      usersProvider.items[i],
                    ),
                    childCount: usersProvider.count,
                  ),
                ),
              ],
            ),
    );
  }
}

ListTile _createUserTile(
    BuildContext context, UsersProvider usersProvider, User user) {
  return ListTile(
    onTap: () {},
    tileColor: user.isEnabled ? Colors.transparent : Colors.black12,
    leading: const CircleAvatar(),
    title: Text(user.fullName),
    subtitle: Text(user.role ?? 'Unkown role'),
    trailing: Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        IconButton(
          onPressed: () {
            // من اجل التعديل على بيانات المستخدم ، نرس معه الايدي الخاص به
            Navigator.pushNamed(context, routes.editUserScreen,
                arguments: user.id);
          },
          icon: const Icon(
            Icons.edit,
            color: Colors.indigo,
          ),
        ),
        IconButton(
          onPressed: () async {
            final ret = await DialogsService.showQuestionDialog(
                    context,
                    Text(
                      'Are you sure you want to delete user `${user.username}\'?',
                    ),
                    title: const Text('Confirm deletion')) ??
                false;

            if (ret) {
              // بيعمل على حذف المستخدم
              await usersProvider.delete(user);
              // بعد عملية الحذف بيطلع شعار انه تم الحذف
              DialogsService.showSnackBar(context, 'User deleted');
            }
          },
          icon: const Icon(
            Icons.clear,
            color: Colors.red,
          ),
        ),
      ],
    ),
  );
}
