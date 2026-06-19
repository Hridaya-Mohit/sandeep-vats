import 'package:go_router/go_router.dart';
import '../../features/home/home_page.dart';
import '../../features/about/about_page.dart';
import '../../features/services/services_page.dart';
import '../../features/testimonials/testimonials_page.dart';
import '../../features/contact/contact_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (ctx, state) => const NoTransitionPage(child: HomePage()),
      ),
      GoRoute(
        path: '/about',
        pageBuilder: (ctx, state) => const NoTransitionPage(child: AboutPage()),
      ),
      GoRoute(
        path: '/services',
        pageBuilder: (ctx, state) => const NoTransitionPage(child: ServicesPage()),
      ),
      GoRoute(
        path: '/testimonials',
        pageBuilder: (ctx, state) => const NoTransitionPage(child: TestimonialsPage()),
      ),
      GoRoute(
        path: '/contact',
        pageBuilder: (ctx, state) => const NoTransitionPage(child: ContactPage()),
      ),
    ],
  );
}
