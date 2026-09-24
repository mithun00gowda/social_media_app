import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_feed_app/core/models/user.dart';
import 'package:uuid/uuid.dart';

class AuthRepository {
  final uuid = Uuid();
  static const _userKey = 'saved_user';
  Future<AppUser> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (password.length < 4) {
      throw Exception('Password too short');
    }
    return AppUser(
      id: uuid.v4(),
      name: email.split('@').first,
      avatarUrl: 'https://i.pravatar.cc/150?u=$email',
    );
  }

  Future<void> saveUserLocally(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode({
      'id': user.id,
      'name': user.name,
      'avatarUrl': user.avatarUrl,
    });
    await prefs.setString(_userKey, userJson);
  }

  Future<AppUser?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    final map = jsonDecode(userJson) as Map<String, dynamic>;
    return AppUser(
      id: map['id'] as String,
      name: map['name'] as String,
      avatarUrl: map['avatarUrl'] as String,
    );
  }

  Future<void> clearSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
