import 'package:waven/domain/entity/user.dart';

abstract class AuthRepository {
  Future<String> onlogin(String ur,String pw);
  Future<String> onSignup(User data);
  Future<String?> getRefreshToken();
  Future<String?> getAccesToken();
  Future<String> logout();
}