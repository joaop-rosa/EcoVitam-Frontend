import 'package:ecovitam/helpers/jwt.dart';
import 'package:ecovitam/view/EventFormView.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class EventFormPresenter {
  final EventFormView view;

  EventFormPresenter(this.view);

  Future<void> registerEvent(
      BuildContext context,
      String title,
      String address,
      String uf,
      String city,
      String contact,
      String dateParam,
      String startHour,
      String finalHour) async {
    view.showLoading();

    String date = '';
    try {
      DateTime dateTime = DateFormat('d/M/yyyy').parse(dateParam);
      date = DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      // Se a data for inválida, exibe uma mensagem de erro ou trata o erro adequadamente
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Formato de data inválido'),
      ));
      view.hideLoading();
      return;
    }

    // Converte a data de nascimento para o formato aaaa-mm-dd
    Map<String, String> body = {
      'titulo': title,
      'endereco': address, // Codifica a senha em Base64
      'estado': uf,
      'cidade': city,
      'contato': contact,
      'data': date,
      'horaInicio': startHour,
      'horaFim': finalHour // A data de nascimento
    };

    final Uri url = Uri.parse('http://10.0.2.2:3000/eventos');
    final authToken = await getToken();
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'authorization': 'Bearer $authToken'
          },
          body: jsonEncode(body));

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
