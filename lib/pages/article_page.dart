import 'package:ecovitam/components/BottomNavigationBarDefault.dart';
import 'package:ecovitam/components/DefaultAppBar.dart';
import 'package:ecovitam/constants/colors.dart';
import 'package:ecovitam/modals/ArticleModal.dart';
import 'package:ecovitam/models/Article.dart';
import 'package:ecovitam/models/User.dart';
import 'package:ecovitam/presenter/ArticlePagePresenter.dart';
import 'package:ecovitam/view/ArticleView.dart';
import 'package:flutter/material.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> implements ArticleView {
  bool isLoading = false;
  bool hasError = false;
  List<Article> articles = [];
  User? user;

  late ArticlePagePresenter presenter;

  @override
  void initState() {
    super.initState();
    presenter = ArticlePagePresenter(this);
    presenter.fetchList(context);
    presenter.initializeData();
  }

  @override
  void setUser(User user) {
    setState(() {
      this.user = user;
    });
  }

  @override
  void showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  @override
  void hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  void showError() {
    setState(() {
      hasError = true;
    });
  }

  @override
  void hideError() {
    setState(() {
      hasError = false;
    });
  }

  @override
  void setArticles(List<Article> articles) {
    setState(() {
      this.articles = articles;
    });
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
            if (user != null && user!.is_admin)
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
                      presenter.fetchList(context);
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
