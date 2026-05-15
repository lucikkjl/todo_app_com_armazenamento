import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import '../models/todo.dart';

class MigrationService {
  Future<void> migrate() async {
    final prefs = await SharedPreferences.getInstance();
    final isMigrated = prefs.getBool('migrated_v1_to_v2') ?? false;

    if (!isMigrated) {
      final oldTodos = prefs.getStringList('v1_todos');
      if (oldTodos != null && oldTodos.isNotEmpty) {
        final box = Hive.box<Todo>('todos');
        for (var title in oldTodos) {
          await box.add(Todo(title: title));
        }
        await prefs.remove('v1_todos');
      }
      await prefs.setBool('migrated_v1_to_v2', true);
    }
  }
}