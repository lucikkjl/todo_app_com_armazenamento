import 'package:hive/hive.dart';
import '../models/todo.dart';

class TodoRepository {
  final Box<Todo> box = Hive.box<Todo>('todos');

  List<Todo> getAll() => box.values.toList();

  Future<void> add(Todo todo) async {
    await box.add(todo);
  }

  Future<void> drop(Todo todo) async {
    await box.delete(todo.hashCode);
  }
}
