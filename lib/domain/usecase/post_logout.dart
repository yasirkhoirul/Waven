import 'package:waven/domain/repository/auth_repository.dart';

class PostLogout {
  final AuthRepository authRepository;
  PostLogout(this.authRepository);
  Future<String> execute(){
    return authRepository.logout();
  }
}