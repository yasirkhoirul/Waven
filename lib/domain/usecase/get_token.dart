import 'package:waven/domain/repository/auth_repository.dart';

class GetToken {
  final AuthRepository authRepository;
  const GetToken(this.authRepository);

  Future<String?> execute(){
    return authRepository.getAccesToken();
  }

  Future<String?> executerefresh(){
    return authRepository.getRefreshToken();
  }

  Future<String> executeRemoveToken()async{
    return authRepository.logout();
  }
}
