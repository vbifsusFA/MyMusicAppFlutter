import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Обязательно добавь этот импорт
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Получаем данные пользователя из AuthProvider
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    // Если вдруг пользователь не найден (защита)
    if (user == null) {
      return Scaffold(body: Center(child: Text("Пользователь не найден")));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Аватарка
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blueAccent,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
            const SizedBox(height: 15),
            // ТЕПЕРЬ ТУТ РЕАЛЬНЫЕ ДАННЫЕ:
            Text(
              user.name, // Показывает то, что ввел при регистрации
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              user.email, // Показывает твой email
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Статистика (пока заглушки, но работают)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem("Треков", user.totalTracks.toString()),
                _buildStatItem("Плейлистов", "0"),
                _buildStatItem("Минут", "0"),
              ],
            ),

            const SizedBox(height: 40),

            // Список настроек
            _buildSettingsTile(Icons.favorite, "Любимые треки", () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Раздел в разработке")),
              );
            }),
            _buildSettingsTile(Icons.settings, "Настройки звука", () {
              // Можно добавить переход на настройки
            }),
            _buildSettingsTile(Icons.dark_mode, "Темная тема", () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Скоро будет доступно")),
              );
            }),
            const Divider(),
            
            // КНОПКА ВЫХОДА (РАБОЧАЯ)
            _buildSettingsTile(Icons.exit_to_app, "Выйти", () {
              _showLogoutDialog(context, authProvider);
            }, isExit: true),
          ],
        ),
      ),
    );
  }

  // Диалоговое окно подтверждения выхода
  void _showLogoutDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Выход"),
        content: const Text("вы точно хотите выйти?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Отмена")),
          TextButton(
            onPressed: () {
              auth.logout(); // Очищаем данные в провайдере
              // Переходим на экран логина и удаляем историю переходов
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
            child: const Text("Выйти", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap, {bool isExit = false}) {
    return ListTile(
      leading: Icon(icon, color: isExit ? Colors.red : Colors.blueAccent),
      title: Text(title, style: TextStyle(color: isExit ? Colors.red : Colors.black)),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    );
  }
}