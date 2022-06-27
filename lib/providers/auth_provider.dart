import 'package:flutter/widgets.dart';

import '../services/http_context.dart';
import '../models/session_user.dart';

class AuthProvider with ChangeNotifier {
  final HttpContext _ctx;

  SessionUser? _session;

  //constructor
  AuthProvider(this._ctx);

  bool get isLoggedIn => _session != null;
  SessionUser? get session => _session;

  /*
  دالة التحقق تذهب الى
    api
    وتعمل عملية تحقق لجزئيه المستخدمية*/

  Future<bool> login(String username, String password) async {
    _session = await _ctx.authenticate(username, password);
    return _session != null;
  }

  Future<void> logout() async {
    _ctx.eraseAuthCreds();
    _session = null;


    // استمع لاي تغير يحصل لاي داله من هذه الدوال
    notifyListeners();
  }
}