import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final List<UserModel> _registeredUsers = [];
  UserModel? _currentUser;
  bool _isLoggedIn = false;

  UserModel? get user => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  Future<String?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final user = _registeredUsers.firstWhere(
        (u) => u.email == email && u.password == password,
      );
      _currentUser = user;
      _isLoggedIn = true;
      notifyListeners();
      return null;
    } catch (e) {
      return "Пользователь не найден или пароль неверен";
    }
  }

  Future<String?> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    // ИСПРАВЛЕНИЕ: Разбиваем условия, чтобы не было ошибок со скобками
    if (name.isEmpty) {
      return "Введите имя";
    }
    if (email.isEmpty) {
      return "Введите email";
    }
    if (password.length < 6) {
      return "Пароль должен быть от 6 символов";
    }

    bool alreadyExists = _registeredUsers.any((u) => u.email == email);
    if (alreadyExists) {
      return "Этот email уже занят";
    }

    final newUser = UserModel(
      name: name,
      email: email,
      password: password,
      avatarUrl: "https://cdn-icons-png.flaticon.com/512/3135/3135715.png",
      totalTracks: 0,
    );

    _registeredUsers.add(newUser);
    _currentUser = newUser;
    _isLoggedIn = true;
    notifyListeners();
    return null;
  }

  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}