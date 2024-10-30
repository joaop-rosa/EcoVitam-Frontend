import 'package:ecovitam/components/BottomNavigationBarDefault.dart';
import 'package:ecovitam/components/DefaultAppBar.dart';
import 'package:ecovitam/constants/colors.dart';
import 'package:ecovitam/helpers/jwt.dart';
import 'package:ecovitam/modals/ArticleModal.dart';
import 'package:ecovitam/models/Article.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  bool isLoading = false;
  bool hasError = false;
  List<Article> articles = [];

  Future<void> fetchList() async {
    setState(() {
      hasError = false;
      isLoading = true;
    });

    final Uri url = Uri.parse('http://10.0.2.2:3000/artigo');

    final authToken = await getToken();
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $authToken'
      });

      if (response.statusCode == 200) {
        List<dynamic> jsonArray = json.decode(response.body);

        List<Article> articleResponse = jsonArray.map((jsonItem) {
          return Article.fromJson(jsonItem);
        }).toList();

        setState(() {
          articles = articleResponse;
        });
      } else {
        setState(() {
          hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const DefaultAppBar(
          hasArrowBack: false,
        ),
        bottomNavigationBar: const BottomNavigationBarDefault(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(27),
          decoration: const BoxDecoration(
            color: background,
          ),
          child: Stack(children: [
            ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return Column(children: [
                    GestureDetector(
                      onTap: () => {
                        Navigator.pushNamed(
                          context,
                          '/article-detailed',
                          arguments: article.id, // Passa o id como argumento
                        )
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              opacity: 0.4,
                              image: NetworkImage(article.imagemUrl),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                            color: Colors.black),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              article.titulo,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15)
                  ]);
                }),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                onPressed: () async {
                  final result = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: const ArticleModal());
                    },
                  );

                  if (result == true) {
                    fetchList();
                  }
                },
                icon: const Icon(
                  Icons.add,
                ),
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(primary),
                  minimumSize: WidgetStatePropertyAll(Size(52, 52)),
                ),
              ),
            )
          ]),
        ));
  }
}
