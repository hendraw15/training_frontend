import 'package:fe_training/provider/auth_provider.dart';
import 'package:fe_training/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, state, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('Login')),
            body: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: state.usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: state.passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 32),
                  state.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                state.login().then((result) {
                                  if (result) {
                                    if (context.mounted) {
                                      context.pushReplacement(Routes.home);
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "Login failed",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  }
                                });
                              },
                              child: const Text('Login'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () {
                                state.regis().then((result) {
                                  if (result) {
                                    Fluttertoast.showToast(
                                      msg: "Registration successful",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  }
                                });
                              },
                              child: const Text('Register'),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
