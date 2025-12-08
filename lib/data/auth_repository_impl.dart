import 'package:logger/web.dart';
import 'package:waven/data/remote/data_local_impl.dart';
import 'package:waven/data/remote/data_remote_impl.dart';
import 'package:waven/domain/entity/user.dart';
import 'package:waven/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DataRemote dataRemote;
  final DataLocal dataLocal;
  const AuthRepositoryImpl({required this.dataRemote, required this.dataLocal});
  @override
  Future<String> onSignup(User data) async {
    try {
      final response = await dataRemote.signUP(data);
      await dataLocal.saveTokens(response.acces, response.refresh);
      return "sukses";
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<String> onlogin(String ur, String pw) async {
    final data = await dataRemote.onLogin(ur, pw);
    try {
      await dataLocal.saveTokens(data.acces, data.refresh);
      return "sukses";
    } catch (e) {
      throw Exception("kesalahan penyimpanan ke lokal ${e.toString()} ");
    }
  }

  @override
  Future<String?> getAccesToken() async {
    return await dataLocal.getAcessToken();
  }

  @override
  Future<String?> getRefreshToken() async {
    return await dataLocal.getRefreshToken();
  }

  @override
  Future<String> logout() async {
    try {
      
      final refresh = await dataLocal.getRefreshToken();
      if (refresh==null) {
        return "refresh token tidak ada";
      }
      Logger().i(refresh);
      final response = await dataRemote.logout(refresh);
      await dataLocal.deleteTokens();
      return response;
    } catch (e) {
      throw Exception("terjadi kesalahan");
    }
  }
}
