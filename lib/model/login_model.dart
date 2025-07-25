import 'dart:convert';

class LoginModel {
  String password;
  String username;

  LoginModel({required this.password, required this.username});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(password: json['password'], username: json['username']);
  }

  Map<String, dynamic> toJson() {
    return {'password': password, 'username': username};
  }
}

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));
String loginModelToJson(LoginModel data) => json.encode(data.toJson());
