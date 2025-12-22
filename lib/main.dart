import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/player_screen.dart';
import 'providers/auth_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'Music App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: PlayerScreen(),
      ),
    );
  }
}

