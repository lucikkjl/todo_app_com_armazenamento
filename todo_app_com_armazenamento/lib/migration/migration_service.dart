import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import '../models/todo.dart';

class MigrationService {
  static const CURRENT_VERSION = 2;

  Future<void> migrate() async {
    final prefs = await SharedPreferences.getInstance();
    final version = prefs.getInt('app_version') ?? 1;

    if (version < 2) {
      await _migrateV1toV2(prefs);
      await prefs.setInt('app_version', 2);
    }
  }

  Future<void> _migrateV1toV2(SharedPreferences prefs) async {
    final oldTodos = prefs.getStringList('todos') ?? [];
    final box = Hive.box<Todo>('todos');

    for (var title in oldTodos) {
      await box.add(Todo(title: title));
    }

    await prefs.remove('todos');
  }
}
