import 'package:ecovitam/helpers/jwt.dart';
import 'package:ecovitam/view/CollectionPointFormView.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CollectionPointFormPresenter {
  final CollectionPointFormView view;

  CollectionPointFormPresenter(this.view);

  Future<void> registerCollectionPoint(BuildContext context, String name,
      String address, String uf, String city, String contact) async {
    view.showLoading();

    // Converte a data de nascimento para o formato aaaa-mm-dd
    Map<String, String> body = {
      'nome': name,
      'endereco': address, // Codifica a senha em Base64
      'estado': uf,
      'cidade': city,
      'contato': contact, // A data de nascimento
    };

    final Uri url = Uri.parse('http://10.0.2.2:3000/ponto-coleta');
    final authToken = await getToken();
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'authorization': 'Bearer $authToken'
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Cadastrado com sucesso'),
        ));
        Navigator.pop(context, true);
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
