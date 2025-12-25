import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';
import 'player_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleLogin() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    
    // Теперь метод login возвращает строку с ошибкой или null
    String? error = await auth.login(_emailController.text, _passwordController.text);
    
    if (error == null) {
      // Если всё ок — идем в плеер
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PlayerScreen()));
    } else {
      // Если ошибка — показываем её пользователю
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Вход в Плеер", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder())),
            SizedBox(height: 15),
            TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: "Пароль", border: OutlineInputBorder())),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text("Войти"),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen())),
              child: Text("Нет аккаунта? Зарегистрироваться"),
            )
          ],
        ),
      ),
    );
  }
}