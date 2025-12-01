import 'package:waven/data/data_remote_impl.dart';
import 'package:waven/domain/entity/user.dart';
import 'package:waven/domain/repository/auth_repository.dart';

class  AuthRepositoryImpl implements AuthRepository {
  final DataRemote dataRemote;
  const AuthRepositoryImpl({required this.dataRemote});
  @override
  Future<String> onSignup(User data) async {
    try {
    final response = await dataRemote.signUP(data);
    return response.message;
    } catch (e) {
     throw e.toString(); 
    }
  }

  @override
  Future<String> onlogin(String ur, String pw)async {
    final data = await dataRemote.onLogin(ur, pw);
    return data;
  }
}