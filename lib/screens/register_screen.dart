import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'player_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleRegister() async {
    final String n = _nameController.text;
    final String e = _emailController.text;
    final String p = _passwordController.text;

    // ПРОВЕРКА ПО ОЧЕРЕДИ (убираем сложные условия из строки 24)
    if (n.isEmpty) {
      _showMsg("Введите имя");
      return;
    }
    if (e.isEmpty) {
      _showMsg("Введите email");
      return;
    }
    if (p.length < 6) {
      _showMsg("Пароль должен быть от 6 символов");
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final String? res = await auth.register(n, e, p);

    if (!mounted) return;

    if (res == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PlayerScreen()),
      );
    } else {
      _showMsg(res);
    }
  }

  void _showMsg(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Регистрация")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Имя")),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Пароль")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _handleRegister, child: const Text("Создать")),
          ],
        ),
      ),
    );
  }
}