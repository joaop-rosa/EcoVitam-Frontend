import 'package:ecovitam/components/BottomNavigationBarDefault.dart';
import 'package:ecovitam/components/DefaultAppBar.dart';
import 'package:ecovitam/constants/colors.dart';
import 'package:ecovitam/helpers/jwt.dart';
import 'package:ecovitam/models/ArticleDetailed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArticleDetailedPage extends StatefulWidget {
  const ArticleDetailedPage({super.key});

  @override
  State<ArticleDetailedPage> createState() => _ArticleDetailedPageState();
}

class _ArticleDetailedPageState extends State<ArticleDetailedPage> {
  bool isLoading = false;
  bool hasError = false;
  ArticleDetailed? article;
  int? articleId;

  Future<void> fetchArticle(int id) async {
    setState(() {
      hasError = false;
      isLoading = true;
    });

    final Uri url = Uri.parse('http://10.0.2.2:3000/artigo/$id');
    final authToken = await getToken();

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $authToken'
      });

      if (response.statusCode == 200) {
        dynamic jsonArray = json.decode(response.body);
        ArticleDetailed articlesResponse = ArticleDetailed.fromJson(jsonArray);

        setState(() {
          article = articlesResponse;
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    final int? id = ModalRoute.of(context)?.settings.arguments as int?;
    if (id != null && id != articleId) {
      articleId = id;
      fetchArticle(articleId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(),
      bottomNavigationBar: const BottomNavigationBarDefault(),
      body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: background,
          ),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : hasError
                  ? const Center(
                      child: Text(
                        'Erro ao carregar o artigo.',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                      children: [
                        Container(
                          height: 180,
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                opacity: 0.4,
                                image: NetworkImage(article!.imagemUrl),
                                fit: BoxFit.cover,
                              ),
                              color: Colors.black),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                article!.titulo,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text('Autor: ${article!.nomeCompleto}'),
                              Text(article!.conteudo)
                            ],
                          ),
                        )
                      ],
                    ))),
    );
  }
}
