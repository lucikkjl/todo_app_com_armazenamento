import 'package:flutter/material.dart';
import 'services/storage_service.dart';
import 'migration/migration_service.dart';
import 'pages/todo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.init();

  final migration = MigrationService();
  await migration.migrate();

  runApp(MaterialApp(home: TodoPage()));
}
