import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/storage_service.dart';
import '../models/user.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  String language = 'pt-BR';
  bool notificationsEnabled = true;

  String token = '';
  
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  
  UserProfile? currentUser;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      isDarkMode = StorageService.prefs.getBool('darkMode') ?? false;
      language = StorageService.prefs.getString('language') ?? 'pt-BR';
      notificationsEnabled = StorageService.prefs.getBool('notifications') ?? true;
    });

    _loadUserProfile();
    _loadToken();
  }

  void _loadUserProfile() {
    final userBox = Hive.box<UserProfile>('user_profile');
    if (userBox.isNotEmpty) {
      currentUser = userBox.getAt(0);
      nameController.text = currentUser!.name;
      emailController.text = currentUser!.email;
    } else {
      currentUser = null;
      nameController.clear();
      emailController.clear();
    }
    setState(() {});
  }

  Future<void> _loadToken() async {
    token = await StorageService.secureStorage.read(key: 'auth_token') ?? 'Nenhum token salvo';
    setState(() {});
  }

  Future<void> _saveTheme(bool val) async {
    setState(() => isDarkMode = val);
    await StorageService.prefs.setBool('darkMode', val);
    themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> _saveLanguage(String val) async {
    setState(() => language = val);
    await StorageService.prefs.setString('language', val);
  }

  Future<void> _saveNotifications(bool val) async {
    setState(() => notificationsEnabled = val);
    await StorageService.prefs.setBool('notifications', val);
  }


  Future<void> _saveProfile() async {
    final userBox = Hive.box<UserProfile>('user_profile');
    
    if (userBox.isEmpty) {
      final newUser = UserProfile(
        name: nameController.text,
        email: emailController.text,
        registrationDate: DateTime.now().toIso8601String().split('T')[0],
        score: 100, 
      );
      await userBox.add(newUser);
    } else {
      final user = userBox.getAt(0)!;
      user.name = nameController.text;
      user.email = emailController.text;
      await user.save();
    }
    _loadUserProfile();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil Salvo com sucesso!')));
  }

  Future<void> _clearProfile() async {
    final userBox = Hive.box<UserProfile>('user_profile');
    await userBox.clear();
    _loadUserProfile();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil apagado (Direito ao esquecimento)')));
  }

  Future<void> _generateToken() async {
    final newToken = 'tok_${DateTime.now().millisecondsSinceEpoch}';
    await StorageService.secureStorage.write(key: 'auth_token', value: newToken);
    _loadToken();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Token gerado com sucesso!')));
  }

  Future<void> _deleteToken() async {
    await StorageService.secureStorage.delete(key: 'auth_token');
    _loadToken();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Token apagado com segurança!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Preferências (SharedPreferences)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDarkMode,
            onChanged: _saveTheme,
          ),
          SwitchListTile(
            title: const Text('Notificações'),
            value: notificationsEnabled,
            onChanged: _saveNotifications,
          ),
          ListTile(
            title: const Text('Idioma'),
            trailing: DropdownButton<String>(
              value: language,
              items: const [
                DropdownMenuItem(value: 'pt-BR', child: Text('Português')),
                DropdownMenuItem(value: 'en-US', child: Text('English')),
              ],
              onChanged: (val) {
                if (val != null) _saveLanguage(val);
              },
            ),
          ),
          const Divider(),
          
          const Text('Perfil do Utilizador (Hive)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nome'),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'E-mail'),
          ),
          if (currentUser != null) ...[
            const SizedBox(height: 8),
            Text('Membro desde: ${currentUser!.registrationDate}'),
            Text('Pontuação: ${currentUser!.score} pts'),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('Salvar Perfil'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearProfile,
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Apagar Perfil'),
                ),
              ),
            ],
          ),
          const Divider(),

          const Text('Segurança (Secure Storage)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text('Token atual: $token', style: const TextStyle(fontFamily: 'monospace')),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _generateToken,
                  child: const Text('Gerar Token'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: _deleteToken,
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Apagar Token'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}