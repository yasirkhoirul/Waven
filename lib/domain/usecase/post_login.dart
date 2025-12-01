import 'package:waven/domain/repository/auth_repository.dart';

class PostLogin {
  final AuthRepository authRepository;
  const PostLogin(this.authRepository);

  Future<String> execute(String ur , String pw) async{
    return await authRepository.onlogin(ur, pw);
  }
}