import 'package:flutter/material.dart';
import '../repositories/todo_repository.dart';
import '../models/todo.dart';

class TodoPage extends StatefulWidget {
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final repo = TodoRepository();
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final todos = repo.getAll();

    return Scaffold(
      appBar: AppBar(title: const Text('Todo Ready App')),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (_, i) {
          final todo = todos[i];
          return ListTile(title: Text(todo.title));
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(child: TextField(controller: controller)),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                if (controller.text.isEmpty) return;
                await repo.add(Todo(title: controller.text));
                controller.clear();
                setState(() {});
              },
            )
          ],
        ),
      ),
    );
  }
}
