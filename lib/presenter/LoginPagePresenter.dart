import 'package:ecovitam/constants/api.dart';
import 'package:ecovitam/helpers/jwt.dart';
import 'package:ecovitam/view/LoginView.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPagePresenter {
  final LoginView view;

  LoginPagePresenter(this.view);

  Future<void> autoLogin(BuildContext context) async {
    final authToken = await getToken();
    try {
      final response = await http.get(
        Uri.parse('$API_URL/check-token'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $authToken'
        },
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } finally {
      view.hideAutoLoginLoading();
    }
  }
}
