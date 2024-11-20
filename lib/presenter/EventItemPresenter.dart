import 'package:ecovitam/helpers/jwt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventItemPresenter {
  Future<void> sendReport(BuildContext context, int id) async {
    final Uri url = Uri.parse('http://10.0.2.2:3000/eventos-denuncia/$id');

    final authToken = await getToken();

    try {
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $authToken'
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Denúncia enviada com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Falha ao enviar denúncia. Tente novamente."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Falha ao enviar denúncia. Tente novamente."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool?> like(BuildContext context, int id) async {
    final Uri url = Uri.parse('http://10.0.2.2:3000/eventos-likes/$id/true');

    final authToken = await getToken();

    try {
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $authToken'
      });

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

  Future<void> delete(BuildContext context, int id) async {
    final Uri url = Uri.parse('http://10.0.2.2:3000/eventos-delete/$id');

    final authToken = await getToken();

    try {
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $authToken'
      });

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/user');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Evento deletado com sucesso"),
            backgroundColor: Colors.green,
          ),
        );
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
  }
}
