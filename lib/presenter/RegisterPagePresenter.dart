import 'package:ecovitam/constants/api.dart';
import 'package:ecovitam/presenter/AuthPresenter.dart';
import 'package:ecovitam/view/RegisterView.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class RegisterPagePresenter {
  final RegisterView view;
  late AuthPresenter authPresenter;

  RegisterPagePresenter(this.view) {
    authPresenter = AuthPresenter(view);
  }

  Future<void> registerUser(
      BuildContext context,
      String birthdateParam,
      String email,
      String password,
      String name,
      String lastName,
      String uf,
      String city) async {
    view.showLoading();

    String birthdate = '';
    try {
      DateTime date = DateFormat('d/M/yyyy').parse(birthdateParam);
      birthdate = DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Formato de data inválido'),
      ));
      view.hideLoading();
      return;
    }

    Map<String, String> body = {
      'email': email,
      'senha': base64Encode(utf8.encode(password)),
      'primeiro_nome': name,
      'ultimo_nome': lastName,
      'estado': uf,
      'cidade': city,
      'data_nascimento': birthdate,
    };

    final Uri url = Uri.parse('$API_URL/user');

    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        authPresenter.login(context, email, password);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro ao registrar: ${response.body}'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro: $e'),
      ));
    } finally {
      view.hideLoading();
    }
  }
}
