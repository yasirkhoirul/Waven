import 'package:go_router/go_router.dart';
import 'package:waven/common/utils/deeplink_handler.dart';
import 'package:waven/presentation/cubit/tokenauth_cubit.dart';
import 'package:waven/presentation/notifier/auth_notifier.dart';
import 'package:waven/presentation/pages/booking_page.dart';
import 'package:waven/presentation/pages/gallery_page.dart';
import 'package:waven/presentation/pages/home_page.dart';
import 'package:waven/presentation/pages/login_page.dart';
import 'package:waven/presentation/pages/main_scaffold_user_page.dart';
import 'package:waven/presentation/pages/package_list_page.dart';
import 'package:waven/presentation/pages/package_page.dart';
import 'package:waven/presentation/pages/profile_page.dart';
import 'package:waven/presentation/pages/signup_page.dart';
import 'package:waven/presentation/pages/splash_page.dart';

class MyRouter {
  static GoRouter getrouter(TokenauthCubit cubit) {
    return GoRouter(
      refreshListenable: CubitListenable(cubit),
      initialLocation: "/splash",
      routes: [
        GoRoute(
          path: '/payment-result',
          name: 'payment-result',
          redirect: (context, state) {
            // Extract payment parameters from deep link
            final params = state.uri.queryParameters;
            final orderId = params['order_id'];
            final status = params['transaction_status'];            
            // Trigger deep link handler callback
            if (orderId != null && status != null) {
              DeepLinkHandler().onPaymentResult?.call(
                orderId,
                status,
                params,
              );
            }
            
            // Redirect to dashboard after handling callback
            return '/Profile';
          },
        ),
        GoRoute(path: "/splash", builder: (context, state) => SplashPage()),
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
                  routes: [
                    
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/packagelist',
                  name: 'packagelist',
                  builder: (context, state) => PackageListPage(),
                  routes: [
                    GoRoute(
                      path: '/package/:id',
                      name: 'package',
                      builder: (context, state) {
                        final id = state.pathParameters['id'];
                        return PackagePage(idpackage: id!);
                      },
                      routes: [
                        GoRoute(
                          path: '/booking',
                          name: 'booking',
                          builder: (context, state) {
                            final data = state.pathParameters['id'];
                            return BookingPage(idpackage: data!);
                          },
                        ),
                      ],
                    ),
                  ]
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/Gallery',
                  builder: (context, state) => GalleryPage(),
                  routes: [
                    
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/Profile',
                  name: 'profile',
                  builder: (context, state) => ProfilePage(),
                  routes: [
                    
                  ],
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
        final allowedRoutesWhenLoggedOut = ['/login', '/signup', '/home', '/Gallery', '/splash','/packagelist'];

        // Jika di splash screen, biarkan saja
        if (state.uri.toString() == '/splash') {
          return null;
        }

        // Jika belum login dan bukan salah satu route yang diizinkan → redirect ke login
        if (!isLoggedIn &&
            !allowedRoutesWhenLoggedOut.contains(state.uri.toString())) {
          return '/login';
        }

        // Jika sudah login dan mencoba ke login atau signup → redirect ke home
        if (isLoggedIn &&
            (state.uri.toString() == '/login' ||
                state.uri.toString() == '/signup')) {
          return '/Profile';
        }
        return null;
      },
    );
  }
}
