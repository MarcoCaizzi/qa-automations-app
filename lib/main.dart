import 'package:flutter/material.dart';

import 'presentation/pages/splash/splash_page.dart';

void main() => runApp(const QAApp());

class QAApp extends StatelessWidget {
  const QAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashPage(),
    );
  }
}
