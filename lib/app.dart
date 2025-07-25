import 'package:fe_training/router.dart';
import 'package:fe_training/utils/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainingApp extends StatelessWidget {
  const TrainingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ApiService(),
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        title: 'Training App',
      ),
    );
  }
}
