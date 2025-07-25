import 'package:fe_training/model/login_model.dart';
import 'package:fe_training/repository/home_repository.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final HomeRepository _homeRepository = HomeRepository();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> login() async {
    isLoading = true;
    final res = await _homeRepository.login(
      LoginModel(
        username: usernameController.text,
        password: passwordController.text,
      ),
    );
    isLoading = false;
    return res;
  }

  Future<bool> regis() async {
    isLoading = true;
    final res = await _homeRepository.regis(
      LoginModel(
        username: usernameController.text,
        password: passwordController.text,
      ),
    );
    isLoading = false;
    return res;
  }
}
