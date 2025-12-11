import 'package:waven/domain/entity/profile.dart';
import 'package:waven/domain/repository/auth_repository.dart';

class GetProfile {
  final AuthRepository authRepository;
  const GetProfile(this.authRepository);

  Future<Profile> execute() async{
    return authRepository.getprofile();
  }
}