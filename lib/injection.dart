

import 'package:get_it/get_it.dart';
import 'package:waven/data/auth_repository_impl.dart';
import 'package:waven/data/data_remote_impl.dart';
import 'package:waven/domain/repository/auth_repository.dart';
import 'package:waven/domain/usecase/post_login.dart';
import 'package:waven/domain/usecase/post_signup.dart';
import 'package:waven/presentation/cubit/auth_cubit.dart';
import 'package:waven/presentation/cubit/signup_cubit.dart';

final locator = GetIt.instance;


Future<void> init()async{
  //cubic
  locator.registerCachedFactory(() => AuthCubit(locator()),);
  locator.registerCachedFactory(() => SignupCubit(locator()),);

  //usecase
  locator.registerLazySingleton(() => PostLogin(locator()),);
  locator.registerLazySingleton(() => PostSignup(locator()),);

  //repositoy
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(dataRemote: locator()),);

  //remote
  locator.registerLazySingleton<DataRemote>(() => DataRemoteImpl(),);

}