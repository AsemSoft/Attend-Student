import 'package:attend/models/base_model.dart';

import '../services/http_context.dart';

abstract class CrudService<T extends BaseModel> {
  final HttpContext httpContext;
  final String basePath;

  const CrudService(this.httpContext, this.basePath);

  Future<T> get(int id) async {
    final path = '$basePath/$id';
    final json = await httpContext.get(path);

    return parseModel(json);
  }

  Future<List<T>> getAll() async {
    final List json = await httpContext.get(basePath);

    return json.map((i) => parseModel(i)).toList();
  }

  Future<T> add(T item) async {
    // parseModel
    // المسار الذي سيتم فيه رفع البيانت basepath
    // بيحول المفات القادمه من المستخدم حتى يحولها obj الى json
    return parseModel(await httpContext.post(basePath, serializeModel(item)));
  }

  Future<void> update(T item) async {
    // put ترسل طلب الى ال اي بي اي تخبره بعمل تحديث على جزء المطلبو
    await httpContext.put('$basePath/${item.id}', item);
  }
  // الداله التي تخبر الـ اي بي اي انه اعمل عملية حذف
  Future<void> delete(T item) async {
    await httpContext.delete('$basePath/${item.id}');
  }

  T parseModel(Map<String, dynamic> json);
  Map<String, dynamic> serializeModel(T model);
}
