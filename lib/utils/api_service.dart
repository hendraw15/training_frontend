import 'dart:developer';

// import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fe_training/utils/nav_service.dart';
import 'package:fe_training/utils/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'environment.dart';

class ApiService extends ChangeNotifier {
  // Environment env = Environment();
  late String baseUrl;

  final Dio dio;
  ApiService() : dio = Dio() {
    dio.interceptors.add(PrettyDioLogger());
    // dio.interceptors.add(ChuckerDioInterceptor());
    _loadBaseUrl();
  }

  String token = '';
  bool isRefreshing = false;
  String getToken() => token;
  Future<void> setToken(String value) async {
    token = value;
    await setAuth();
    notifyListeners();
  }

  Future<void> loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? storedToken = prefs.getString('token');
    if (storedToken != null && storedToken.isNotEmpty) {
      await setToken(storedToken);
    }
  }

  Future<void> setAuth() async {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (token.isNotEmpty) {
            options.headers = {
              'Content-Type': 'application/json',
              'Authorization': token,
            };
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          log(e.stackTrace.toString());
          log(e.message.toString());
          if (e.response?.statusCode == 401) {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            prefs.setBool('isLoggedIn', false);
            prefs.setString('token', '');
            BuildContext context = NavService.navKey.currentContext!;
            if (context.mounted) {
              while (context.canPop()) {
                context.pop();
              }
              context.go(Routes.login);
              const snackbar = SnackBar(
                content: Text('Token Invalid. Please log in again.'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
          }
        },
      ),
    );
  }

  void _loadBaseUrl() {
    baseUrl = 'http://localhost:3000/api/v1';
  }
}
