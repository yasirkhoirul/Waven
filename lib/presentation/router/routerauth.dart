import 'package:go_router/go_router.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';
import 'package:waven/presentation/notifier/auth_notifier.dart';
import 'package:waven/presentation/pages/home_page.dart';
import 'package:waven/presentation/pages/login_page.dart';
import 'package:waven/presentation/pages/main_scaffold_user_page.dart';
import 'package:waven/presentation/pages/signup_page.dart';

class MyRouter {
  static GoRouter getrouter(TokenauthCubit cubit) {
    return GoRouter(
      refreshListenable: CubitListenable(cubit),
      initialLocation: "/login",
      routes: [
        GoRoute(path: "/login", builder: (context, state) => LoginPage()),
        GoRoute(path: "/signup", builder: (context, state) => SignupPage()),

        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              MainScaffoldUserPage(statefulNavigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) => WavenHomePage(),
                ),
              ],
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final token = cubit.state.tokens;
        final isLoggedIn = token != null;
        // Routes yang boleh diakses saat belum login
        final allowedRoutesWhenLoggedOut = ['/login', '/signup'];

        // Jika belum login dan bukan salah satu route yang diizinkan → redirect ke login
        if (!isLoggedIn &&
            !allowedRoutesWhenLoggedOut.contains(state.uri.toString())) {
          return '/login';
        }

        // Jika sudah login dan mencoba ke login atau signup → redirect ke home
        if (isLoggedIn &&
            (state.uri.toString() == '/login' ||
                state.uri.toString() == '/signup')) {
          return '/home';
        }
        return null;
      },
    );
  }
}
