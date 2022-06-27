import 'package:attend/models/base_model.dart';
import 'package:attend/services/crud_service.dart';
import 'package:flutter/material.dart';

class CrudProvider<T extends BaseModel> with ChangeNotifier {
  final CrudService<T> service;
  final List<T> _items = [];

  List<T> get items => _items;
  int get count => _items.length;

  CrudProvider(this.service);

  Future<T> loadItem(int id) async {
    final idx = _items.indexWhere((i) => i.id == id);

    if (idx < 0) {
      return await service.get(id);
    }

    return _items[idx];
  }

  T getItem(int id) {
    return _items.firstWhere((i) => i.id == id);
  }

  Future<void> refresh() async {
    _items.clear();
    _items.addAll(await service.getAll());

    notifyListeners();
  }
  // عمل داله الرفع
  Future<void> add(T item) async {

    final retItem = await service.add(item);
    // _items عباره عن قائمة تقوم بخزن المستخدمين
    _items.add(retItem);

    notifyListeners();
  }
  // داله تعمل على تحديث البيانات
  Future<void> update(T item) async {
    await service.update(item);

    final idx = _items.indexWhere((i) => i.id == item.id);

    if (idx < 0) {
      _items.add(item);
    } else {
      _items[idx] = item;
    }

    notifyListeners();
  }
    // داله الحذف
  Future<void> delete(T item) async {
    await service.delete(item);
    _items.remove(item);

    notifyListeners();
  }
}
