import 'package:expense_tracker/feature/launch/launch.dart';
import 'package:expense_tracker/feature/users/presentation/users.dart';
import 'package:expense_tracker/presentation/home.dart';
import 'package:expense_tracker/splash_screen.dart';
import 'package:go_router/go_router.dart';

enum AppRoutes {
  launch('/'),
  splash('/splash'),
  home('/home'),
  users('/users');

  final String path;

  const AppRoutes(this.path);

  static AppRoutes? fromName(String name) {
    try {
      return AppRoutes.values.firstWhere((r) => r.name == name);
    } catch (_) {
      return null;
    }
  }

  static List<RouteBase> get routes => [
    GoRoute(path: launch.path, builder: (context, state) => const LaunchApp()),
    GoRoute(
      path: splash.path,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: home.path,
      builder: (context, state) => const HomeContainer(),
    ),
    GoRoute(path: users.path, builder: (context, state) => const UsersScreen()),
  ];
}
