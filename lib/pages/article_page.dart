import 'package:ecovitam/components/BottomNavigationBarDefault.dart';
import 'package:ecovitam/components/DefaultAppBar.dart';
import 'package:flutter/material.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: DefaultAppBar(
          hasArrowBack: false,
        ),
        bottomNavigationBar: BottomNavigationBarDefault());
  }
}
