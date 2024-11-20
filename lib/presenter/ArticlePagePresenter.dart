import 'package:ecovitam/constants/api.dart';
import 'package:ecovitam/helpers/jwt.dart';
import 'package:ecovitam/models/Article.dart';
import 'package:ecovitam/models/User.dart';
import 'package:ecovitam/view/ArticleView.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class ArticlePagePresenter {
  final ArticleView view;

  ArticlePagePresenter(this.view);

  Future<void> initializeData() async {
    final token = await getToken();
    if (token != null) {
      final decodedToken = JwtDecoder.decode(token);
      view.setUser(User.fromJson(jsonDecode(decodedToken['user'])));
    }
  }

  Future<void> fetchList(BuildContext context) async {
    view.hideError();
    view.showLoading();

    final Uri url = Uri.parse('$API_URL/artigo');

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
        List<dynamic> jsonArray = json.decode(response.body);

        List<Article> articleResponse = jsonArray.map((jsonItem) {
          return Article.fromJson(jsonItem);
        }).toList();

        view.setArticles(articleResponse);
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
