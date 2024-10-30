import 'package:ecovitam/components/BottomNavigationBarDefault.dart';
import 'package:ecovitam/components/DefaultAppBar.dart';
import 'package:ecovitam/constants/colors.dart';
import 'package:flutter/material.dart';

class ArticleDetailedPage extends StatefulWidget {
  const ArticleDetailedPage({super.key});

  @override
  State<ArticleDetailedPage> createState() => _ArticleDetailedPageState();
}

class _ArticleDetailedPageState extends State<ArticleDetailedPage> {
  @override
  Widget build(BuildContext context) {
    final int id = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
        appBar: const DefaultAppBar(),
        bottomNavigationBar: const BottomNavigationBarDefault(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(27),
          decoration: const BoxDecoration(
            color: background,
          ),
        ));
  }
}
