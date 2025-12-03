

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:waven/data/auth_repository_impl.dart';
import 'package:waven/data/data_local_impl.dart';
import 'package:waven/data/data_remote_impl.dart';
import 'package:waven/domain/repository/auth_repository.dart';
import 'package:waven/domain/usecase/get_token.dart';
import 'package:waven/domain/usecase/post_login.dart';
import 'package:waven/domain/usecase/post_signup.dart';
import 'package:waven/presentation/cubit/auth_cubit.dart';
import 'package:waven/presentation/cubit/signup_cubit.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';

final locator = GetIt.instance;


Future<void> init()async{
  //cubic
  locator.registerCachedFactory(() => AuthCubit(locator(), getToken: locator()),);
  locator.registerCachedFactory(() => SignupCubit(locator()),);
  locator.registerCachedFactory(() => TokenauthCubit(locator()),);

  //usecase
  locator.registerLazySingleton(() => PostLogin(locator()),);
  locator.registerLazySingleton(() => PostSignup(locator()),);
  locator.registerLazySingleton(() => GetToken(locator()),);

  //repositoy
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(dataRemote: locator(), dataLocal: locator()),);

  //remote
  locator.registerLazySingleton<DataRemote>(() => DataRemoteImpl(),);
  locator.registerLazySingleton<DataLocal>(() => DataLocalImpl(locator()),);

  //storage secure
  locator.registerLazySingleton(() => FlutterSecureStorage(),);

}