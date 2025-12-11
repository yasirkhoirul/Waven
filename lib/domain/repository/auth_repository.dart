import 'package:waven/domain/entity/profile.dart';
import 'package:waven/domain/entity/user.dart';

abstract class AuthRepository {
  Future<String> onlogin(String ur,String pw);
  Future<String> onlogingoogle();
  Future<String> onSignup(User data);
  Future<String?> getRefreshToken();
  Future<String?> getAccesToken();
  Future<String> logout();
  Future<Profile> getprofile();
}