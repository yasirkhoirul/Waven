import 'package:waven/domain/entity/user.dart';
import 'package:waven/domain/repository/auth_repository.dart';

class PostSignup {
  final AuthRepository authRepository;
  const PostSignup(this.authRepository);

  Future<String> execute( User data )async{
    return authRepository.onSignup(data);
  }
}