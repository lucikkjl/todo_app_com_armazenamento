import 'package:hive_flutter/hive_flutter.dart';
import '../models/todo.dart';

class StorageService {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    await Hive.openBox<Todo>('todos');
  }
}
