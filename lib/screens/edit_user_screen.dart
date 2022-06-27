import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../extensions/string_extensions.dart';
import '../models/session_user.dart';
import '../services/http_error.dart';
import '../util/dialogs_service.dart';
import '../models/user.dart';
import '../util/validator.dart';
import '../providers/users_provider.dart';
import '../widgets/large_submit_button.dart';
import '../widgets/section_header.dart';
import '../widgets/switch_tile.dart';
import '../widgets/user_role_selector.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({Key? key}) : super(key: key);

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  User? _editUser;

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  String? _selectedRole;
  bool _isEnabled = true;
  bool _isLoading = false;

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() => _isLoading = true);

    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    // ننشأ اوبجت من موديل المستخدمين من اجل حفظ البيانات على الموديل
    final user = User(
      id: _editUser?.id ?? 0,
      username: _usernameController.text,
      password: _editUser == null ? _passwordController.text : null,
      email: _emailController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      isEnabled: _isEnabled,
      role: _selectedRole,
    );

    try {
      // اذا المستخدم جديد بيحقق الشرط الاول
      if (_editUser == null) {
        // من اجل رفع البيانت الى قواعد البيانات
        await usersProvider.add(user);
      } else {
        // اذا المستخدم موجود وتريد تحديث بيانته
        await usersProvider.update(user);
      }
      // بعد ما يكمل عملية تحديث او اضافة مستخدم يعمل على الرجوع لصفحة السابقة و يعمل اشعار بعملية تم الحفظ
      Navigator.pop(context);
      DialogsService.showSnackBar(context, 'User saved');
    } on HttpError catch (ex) {
      DialogsService.showSnackBar(context, ex.message.capitalize());
    }
    // تعمل على تغير حاله الرفع من true الى false
    setState(() => _isLoading = false);
  }

  SwitchTile _createIsEnabledSwitchTile() {
    return SwitchTile(
      label: 'Is Enabled?',
      initValue: _isEnabled,
      onChanged: (x) => _isEnabled = x,
    );
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final id = ModalRoute.of(context)!.settings.arguments as int?;

    if (id != null) {
      _editUser = usersProvider.getItem(id);
      _usernameController.text = _editUser!.username;
      _emailController.text = _editUser!.email;
      _firstNameController.text = _editUser!.firstName;
      _lastNameController.text = _editUser!.lastName;
    }

    _isEnabled = _editUser?.isEnabled ?? true;
    _selectedRole = _editUser?.role ?? 'student';

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(_editUser == null ? 'Add a new user' : 'Edit user'),
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
                  children: <Widget>[
                    const SectionHeader(
                      title: 'Account info',
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        label: Text('Username'),
                        prefixIcon: Icon(Icons.alternate_email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: Validator.validateUsername,
                    ),
                    if (_editUser == null) ...[
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          label: Text('Password'),
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Password is required' : null,
                      ),
                      const SizedBox(height: 16),
                      UserRoleSelector(
                          onChanged: (role) =>
                              _selectedRole = getRoleString(role)),
                      const SizedBox(height: 16),
                    ],
                    const SectionHeader(
                      title: 'User info',
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              label: Text('First name'),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                Validator.validateNotEmpty(value, 'First name'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              label: Text('Last name'),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                Validator.validateNotEmpty(value, 'Last name'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        label: Text('Email'),
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: Validator.validateEmail,
                    ),
                    const SizedBox(height: 16),
                    _createIsEnabledSwitchTile(),
                    const SizedBox(height: 32),
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
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();

    super.dispose();
  }
}
