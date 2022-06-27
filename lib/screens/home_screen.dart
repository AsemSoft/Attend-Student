import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes.dart' as routes;
import '../models/session_user.dart';
import '../widgets/rounded_bottom_app_bar.dart';
import '../widgets/rounded_bottom_app_bar_item.dart';
import '../widgets/user_header.dart';
import '../pages/admin_home_page.dart';
import '../pages/courses_management_page.dart';
import '../pages/courses_page.dart';
import '../pages/instructor_home_page.dart';
import '../pages/lectures_page.dart';
import '../pages/student_home_page.dart';
import '../pages/users_managment_page.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController(initialPage: 0, keepPage: false);
  PageView? _pageView;

  @override
  void initState() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    List<Widget> pages = [];
    // هنا يتحقق من نوع المستخدم الذي بيدخل
    if (authProvider.session != null) {
      switch (authProvider.session!.role) {
        // اذا كان المدير مع كلمة السر حقه بيدخل في هذه الحاله
        case UserRole.root:
        case UserRole.admin:
          pages = const [
            AdminHomePage(),
            UsersManagmentPage(),
            CoursesManagmentPage()
          ];
          break;
          // اذا كان الاستاذ او المعلم بيدخل بهذه الحاله
        case UserRole.instructor:
          pages = const [InstructorHomePage(), CoursesPage(), LecturesPage()];
          break;
        case UserRole.student:
          pages = const [StudentHomePage(), CoursesPage(), LecturesPage()];
          break;
      }
    }

    // pages     على حسب المستخدم بيعرض
    _pageView = PageView(
      children: pages,
      controller: _pageController,
      onPageChanged: (_) => setState(() {}),
    );

    super.initState();
  }

  void _navigateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );

    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final session = authProvider.session;

    if (session == null) {
      return Container();
    }

    return Scaffold(
      //extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // session حسب نوع المستخدم بيعرض اسم المستخدم
        title: UserHeader(username: session.username),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.black87,
            ),
          ),
          IconButton(
            onPressed: () async {
              // هنا داله الخروج من التطبيق
              authProvider.logout();
              Navigator.pushReplacementNamed(context, routes.loginScreen);
            },
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.black87,
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _pageView,
      bottomNavigationBar: RoundedBottomAppBar(
        items: <NavigationItem>[
          NavigationItem(
            label: 'Home',
            icon: Icons.home_filled,
            onClick: _navigateToPage,
          ),
          NavigationItem(
            label: session.isRootOrAdmin() ? 'Users' : 'Courses',
            icon: session.isRootOrAdmin() ? Icons.person_outlined : Icons.chrome_reader_mode,
            onClick: _navigateToPage,
          ),
          NavigationItem(
            label: session.isRootOrAdmin() ? 'Courses' : 'Lectures',
            icon: session.isRootOrAdmin() ? Icons.chrome_reader_mode : Icons.developer_board_rounded,
            onClick: _navigateToPage,
          ),
        ],
        selectedIndex: _pageController.positions.isEmpty
            ? 0
            : (_pageController.page ?? 0).round(),
      ),
      floatingActionButton: Transform.translate(
        offset: Offset.fromDirection(2, 20),
        child: FloatingActionButton(
          // في داله بحث لكن في الحقيقه لا يوجد اي باك اند لعمل الداله
          onPressed: () {},
          child: const Icon(Icons.search),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
