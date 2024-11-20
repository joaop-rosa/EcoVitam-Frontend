import 'package:ecovitam/constants/api.dart';
import 'package:ecovitam/view/AuthView.dart';
import 'package:flutter/material.dart';
import 'package:ecovitam/helpers/jwt.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthPresenter {
  final AuthView view;

  AuthPresenter(this.view);

  Future<void> login(
      BuildContext context, String emailParam, String passwordParam) async {
    view.showLoading();

    final String email = emailParam;
    final String password = base64Encode(utf8.encode(passwordParam));

    String basicAuth = 'Basic ${base64Encode(utf8.encode('$email:$password'))}';

    try {
      final response = await http.post(
        Uri.parse('$API_URL/login'),
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/json',
        },
      );

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
        final responseData = jsonDecode(response.body);
        String token = responseData['token'];
        await storeToken(token);

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Login falhou. Verifique suas credenciais.')),
        );
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Ocorreu um erro. Tente novamente mais tarde.')),
      );
      Navigator.pushReplacementNamed(context, '/');
    } finally {
      view.hideLoading();
    }
  }
}
