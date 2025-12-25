class UserModel {
  final String name;
  final String email;
  final String password; // Добавили пароль
  final String avatarUrl;
  final int totalTracks;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.avatarUrl,
    required this.totalTracks,
  });
}