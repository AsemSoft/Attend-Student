import 'package:attend/models/session_user.dart';
import 'package:attend/services/crud_service.dart';
import 'package:attend/services/http_context.dart';

import '../models/user.dart';

class UsersSerivce extends CrudService<User> {
  UsersSerivce(HttpContext ctx, String basePath) : super(ctx, basePath);

  @override
  User parseModel(Map<String, dynamic> json) {
    var ret = User.fromJson(json);

    if (json.containsKey('role')) {
      ret.role = json['role'];
    }

    return ret;
  }

  Future<List<User>> getByCategory(UserRole role) async {
    final roleString = getRoleString(role);

    final List json = await httpContext.get(
      '$basePath/by-category/$roleString',
    );

    return json.map((i) {
      i['role'] = roleString;
      return parseModel(i);
    }).toList();
  }

  @override
  Future<User> add(User item) async {
    final json = await httpContext.post(basePath, item, queryParameters: {
      'role': item.role,
      'password': item.password ?? '',
    })
      ..['role'] = item.role;

    return User.fromJson(json);
  }

  @override
  Map<String, dynamic> serializeModel(User model) {
    return model.toJson();
  }
}
