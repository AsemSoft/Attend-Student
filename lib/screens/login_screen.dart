import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../extensions/string_extensions.dart';
import '../routes.dart' as routes;
import '../providers/auth_provider.dart';
import '../config.dart';
import '../util/validator.dart';
import '../services/http_error.dart';
import '../util/dialogs_service.dart';
import '../widgets/large_submit_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() => _isLoading = true);

    // ننشأ اوبجكت من
    //  AuthProvider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      // هنا يتحقق من الداله login
      // في حاله حق اسم المستخدم وكلمة المرور بيدخل مالم بيطلع خطأ
      final ret = await authProvider.login(
          _usernameController.text, _passwordController.text);

      if (!ret) {
        DialogsService.showSnackBar(context, 'Invlaid username or password');
      } else {
        Navigator.pushReplacementNamed(context, routes.homeScreen);
      }
    } on HttpError catch (ex) {
      DialogsService.showSnackBar(context, ex.message.capitalize());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                margin: const EdgeInsets.only(top: 128),
                padding: const EdgeInsets.all(32),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: backgroundMutedColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('ATTEND',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 48,
                        )),
                    const Text('Attendance managment system'),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                      child: Text(
                        'Login to your university account',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            enabled: !_isLoading,
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.person),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {},
                              ),
                            ),
                            validator: Validator.validateUsername,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            enabled: !_isLoading,
                            controller: _passwordController,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.remove_red_eye),
                                onPressed: () {},
                              ),
                            ),
                            validator: (value) =>
                                Validator.validateNotEmpty(value, 'Password'),
                          ),
                          const SizedBox(height: 32),
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : LargeSubmitButton(
                                  label: 'LOGIN',
                                  icon: Icons.arrow_forward,
                                  onPressed: _submit,
                                ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'HAVING ISSUES?',
                              style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 2,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
