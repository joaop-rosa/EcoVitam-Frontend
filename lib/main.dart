import 'package:flutter/material.dart';

import 'package:ecovitam/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
            backgroundColor: const Color.fromARGB(255, 56, 67, 57)),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
