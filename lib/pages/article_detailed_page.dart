import 'package:ecovitam/components/BottomNavigationBarDefault.dart';
import 'package:ecovitam/components/DefaultAppBar.dart';
import 'package:ecovitam/constants/colors.dart';
import 'package:ecovitam/models/ArticleDetailed.dart';
import 'package:ecovitam/presenter/ArticleDetailedPagePresenter.dart';
import 'package:ecovitam/view/ArticleDetailedView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ArticleDetailedPage extends StatefulWidget {
  const ArticleDetailedPage({super.key});

  @override
  State<ArticleDetailedPage> createState() => _ArticleDetailedPageState();
}

class _ArticleDetailedPageState extends State<ArticleDetailedPage>
    implements ArticleDetailedView {
  bool isLoading = false;
  bool hasError = false;
  ArticleDetailed? article;
  int? articleId;
  late bool? isLiked = null;

  late ArticleDetailedPagePresenter presenter;

  @override
  void initState() {
    super.initState();
    presenter = ArticleDetailedPagePresenter(this);
  }

  @override
  void hideError() {
    setState(() {
      hasError = false;
    });
  }

  @override
  void hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  void setArticle(ArticleDetailed article) {
    setState(() {
      this.article = article;
      isLiked = this.article!.user_feedback;
    });
  }

  @override
  void showError() {
    setState(() {
      hasError = true;
    });
  }

  @override
  void showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final int? id = ModalRoute.of(context)?.settings.arguments as int?;
    if (id != null && id != articleId) {
      articleId = id;
      presenter.fetchArticle(context, articleId!);
    }
  }

  int getLikeNumber() {
    if ((article!.user_feedback == null || article!.user_feedback == false) &&
        isLiked == true) {
      return article!.total_likes + 1;
    }

    if (article!.user_feedback == true &&
        (isLiked == false || isLiked == null)) {
      return article!.total_likes - 1;
    }

    return article!.total_likes;
  }

  int getDislikeNumber() {
    if ((article!.user_feedback == null || article!.user_feedback == true) &&
        isLiked == false) {
      return article!.total_dislikes + 1;
    }

    if (article!.user_feedback == false &&
        (isLiked == true || isLiked == null)) {
      return article!.total_dislikes - 1;
    }

    return article!.total_dislikes;
  }

  Widget renderContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return const Center(
        child: Text(
          'Erro ao carregar o artigo.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return SingleChildScrollView(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Autor: ${article!.nomeCompleto}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 15,
              ),
              MarkdownBody(
                  data: article!.conteudo,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(color: Colors.white),
                    h1: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                    h2: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                    h3: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                    h4: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    h5: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    h6: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    strong: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    em: const TextStyle(
                        color: Colors.white, fontStyle: FontStyle.italic),
                    blockquote: const TextStyle(
                        color: Colors.white70, fontStyle: FontStyle.italic),
                    code: const TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.black54,
                      fontFamily: 'monospace',
                    ),
                    listBullet: const TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                height: 40,
              ),
              Column(
                children: [
                  const Text('Gostou do conteúdo?',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLiked == true
                              ? sucess
                              : Colors.white, // Cor dinâmica
                          foregroundColor: Colors.white, // Cor do texto/ícones
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Bordas arredondadas
                          ),
                        ),
                        onPressed: () async {
                          final success =
                              await presenter.like(context, article!.id, true);
                          if (success != null) {
                            setState(() {
                              if (isLiked == true) {
                                isLiked = null;
                              } else {
                                isLiked = true;
                              }
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.thumb_up_alt,
                              color: isLiked == true
                                  ? Colors.white
                                  : sucess, // Cor do ícone
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Sim (${getLikeNumber()})',
                              style: TextStyle(
                                color: isLiked == true
                                    ? Colors.white
                                    : sucess, // Cor do texto
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLiked == false
                              ? danger
                              : Colors.white, // Cor dinâmica
                          foregroundColor: Colors.white, // Cor do texto/ícones
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Bordas arredondadas
                          ),
                        ),
                        onPressed: () async {
                          final success =
                              await presenter.like(context, article!.id, false);
                          if (success != null) {
                            setState(() {
                              if (isLiked == false) {
                                isLiked = null;
                              } else {
                                isLiked = false;
                              }
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.thumb_up_alt,
                              color: isLiked == false
                                  ? Colors.white
                                  : danger, // Cor do ícone
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Não (${getDislikeNumber()})',
                              style: TextStyle(
                                color: isLiked == false
                                    ? Colors.white
                                    : danger, // Cor do texto
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(),
      bottomNavigationBar: const BottomNavigationBarDefault(),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: background,
          ),
          child: renderContent()),
    );
  }
}
