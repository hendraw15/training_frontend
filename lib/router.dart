import 'package:fe_training/screens/auth/login_page.dart';
import 'package:fe_training/screens/home_page.dart';
import 'package:fe_training/utils/nav_service.dart';
import 'package:fe_training/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The route configuration.
final GoRouter router = GoRouter(
  observers: [ChuckerFlutter.navigatorObserver],
  navigatorKey: NavService.navKey,
  initialLocation: Routes.home,
  redirect: (context, state) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      return Routes.login;
    }
    return null;
  },
  routes: [
    GoRoute(
      name: "login",
      path: Routes.login,
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      name: "home",
      path: Routes.home,
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
  ],
);
