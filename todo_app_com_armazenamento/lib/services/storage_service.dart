import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/todo.dart';
import '../models/user.dart';

class StorageService {
  static late SharedPreferences prefs;
  static final secureStorage = const FlutterSecureStorage();

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    
    await Hive.initFlutter();
    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(UserProfileAdapter());
    
    await Hive.openBox<Todo>('todos');
    await Hive.openBox<UserProfile>('user_profile');
  }
}