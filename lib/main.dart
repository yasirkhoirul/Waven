import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:waven/presentation/cubit/auth_cubit.dart';
import 'package:waven/presentation/cubit/signup_cubit.dart';
import 'package:waven/presentation/pages/login_page.dart';
import 'package:waven/presentation/router/routerauth.dart';
import 'injection.dart' as injection;
final GetIt getisinstance = GetIt.instance;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  injection.init();
  runApp(
    MultiBlocProvider(providers: [
      BlocProvider(create: (context) => getisinstance<SignupCubit>(),),
      BlocProvider(create: (context) => getisinstance<AuthCubit>(),)
    ], child: const MainApp())
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: MyRouter.router,
    );
  }
}
