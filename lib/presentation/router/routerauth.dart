import 'package:go_router/go_router.dart';
import 'package:waven/presentation/pages/login_page.dart';
import 'package:waven/presentation/pages/signup_page.dart';

class MyRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/login",
    routes: [
      GoRoute(path: "/login", builder: (context, state) => LoginPage()),
      GoRoute(path: "/signup", builder: (context, state) => SignupPage()),
    ],
  );
}
