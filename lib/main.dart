import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:waven/domain/usecase/get_detail_invoice.dart';
import 'package:waven/presentation/cubit/auth_cubit.dart';
import 'package:waven/presentation/cubit/booking_cubit.dart';
import 'package:waven/presentation/cubit/detail_invoice_cubit.dart';
import 'package:waven/presentation/cubit/list_invoice_cubit.dart';
import 'package:waven/presentation/cubit/package_all_cubit.dart';
import 'package:waven/presentation/cubit/package_detail_cubit.dart';
import 'package:waven/presentation/cubit/porto_all_cubit.dart';
import 'package:waven/presentation/cubit/profile_cubit.dart';
import 'package:waven/presentation/cubit/signup_cubit.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';
import 'package:waven/presentation/router/routerauth.dart';
import 'injection.dart' as injection;
final GetIt getisinstance = GetIt.instance;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  injection.init();
  runApp(
    MultiBlocProvider(providers: [
      BlocProvider(create: (context) => getisinstance<SignupCubit>(),),
      BlocProvider(create: (context) => getisinstance<AuthCubit>(),),
      BlocProvider(create: (context) => getisinstance<TokenauthCubit>()..getTokens(),),
      BlocProvider(create: (context) => getisinstance<PortoAllCubit>()..getAllporto(),),
      BlocProvider(create: (context) => getisinstance<PackageAllCubit>(),),
      BlocProvider(create: (context) => getisinstance<PackageDetailCubit>(),),
      BlocProvider(create: (context) => getisinstance<BookingCubit>(),),
      BlocProvider(create: (context) => getisinstance<ListInvoiceCubit>(),),
      BlocProvider(create: (context) => getisinstance<ProfileCubit>(),),
      BlocProvider(create: (context) => getisinstance<DetailInvoiceCubit>(),),
    ], child: const MainApp())
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        // 3. Ambil instance Cubit
          final authCubit = context.read<TokenauthCubit>();
          
          // 4. Masukkan ke dalam Router
          final router = MyRouter.getrouter(authCubit);
        return MaterialApp.router(
          routerConfig: router,
        );
      }
    );
  }
}
