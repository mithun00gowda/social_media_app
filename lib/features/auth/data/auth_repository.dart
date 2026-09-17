import 'package:social_feed_app/core/models/user.dart';
import 'package:uuid/uuid.dart';

class AuthRepository {
  final uuid = Uuid();
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
}
