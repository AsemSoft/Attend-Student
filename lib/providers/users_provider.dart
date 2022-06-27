import 'package:attend/models/session_user.dart';
import 'package:attend/providers/crud_provider.dart';
import 'package:attend/services/crud_service.dart';
import 'package:attend/services/users_service.dart';

import '../models/user.dart';

class UsersProvider extends CrudProvider<User> {
  UsersProvider(CrudService<User> service) : super(service);

  Future<List<User>> loadByCategory(UserRole role) async {
    if (service is UsersSerivce) {
      return await (service as UsersSerivce).getByCategory(role);
    }

    throw TypeError();
  }
}
