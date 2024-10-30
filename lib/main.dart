import 'package:ecovitam/pages/article_detailed_page.dart';
import 'package:ecovitam/pages/article_page.dart';
import 'package:ecovitam/pages/home_page.dart';
import 'package:ecovitam/pages/register_page.dart';
import 'package:ecovitam/pages/user_page.dart';
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
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/article': (context) => const ArticlePage(),
        '/article-detailed': (context) => const ArticleDetailedPage(),
        '/user': (context) => const UserPage(),
      },
    );
  }
}
