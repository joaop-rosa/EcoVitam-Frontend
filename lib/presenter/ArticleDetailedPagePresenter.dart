import 'package:ecovitam/models/ArticleDetailed.dart';
import 'package:ecovitam/view/ArticleDetailedView.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ecovitam/helpers/jwt.dart';

class ArticleDetailedPagePresenter {
  final ArticleDetailedView view;
  String lastQueryName = '';
  String lastQueryCity = '';

  ArticleDetailedPagePresenter(this.view);

  Future<bool?> like(BuildContext context, int id, bool isLiked) async {
    final Uri url = Uri.parse('http://10.0.2.2:3000/artigo-likes/$id/$isLiked');
    final authToken = await getToken();

    try {
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $authToken'
      });

      if (response.statusCode == 401) {
        await deleteToken();
        Navigator.pushReplacementNamed(context, '/login');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Seu login expirou, faça login novamente para continuar"),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (response.statusCode == 200) {
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ocorreu um erro, tente novamente"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ocorreu um erro, tente novamente"),
          backgroundColor: Colors.red,
        ),
      );
    }

    return null;
  }

  Future<void> fetchArticle(BuildContext context, int id) async {
    view.hideError();
    view.showLoading();

    final Uri url = Uri.parse('http://10.0.2.2:3000/artigo/$id');
    final authToken = await getToken();

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $authToken'
      });

      if (response.statusCode == 401) {
        await deleteToken();
        Navigator.pushReplacementNamed(context, '/login');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Seu login expirou, faça login novamente para continuar"),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (response.statusCode == 200) {
        dynamic jsonArray = json.decode(response.body);
        ArticleDetailed articlesResponse = ArticleDetailed.fromJson(jsonArray);

        view.setArticle(articlesResponse);
      } else {
        view.showError();
      }
    } catch (e) {
      view.showError();
    } finally {
      view.hideLoading();
    }
  }
}
