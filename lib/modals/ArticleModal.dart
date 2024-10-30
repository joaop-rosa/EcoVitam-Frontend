import 'package:ecovitam/components/Button.dart';
import 'package:ecovitam/components/form/CustomTextFormField.dart';
import 'package:ecovitam/constants/colors.dart';
import 'package:ecovitam/helpers/jwt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArticleModal extends StatefulWidget {
  const ArticleModal({super.key});

  @override
  _ArticleModalState createState() => _ArticleModalState();
}

class _ArticleModalState extends State<ArticleModal> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool isLoading = false;

  Future<void> registerArticle() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, String> body = {
        'titulo': _titleController.text,
        'url_imagem_capa': _imageUrlController.text,
        'conteudo': _contentController.text,
      };

      final Uri url = Uri.parse('http://10.0.2.2:3000/artigo');
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
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
                key: _formKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  CustomTextFormField(
                    controller: _titleController,
                    hintText: 'Titulo',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o Titulo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    controller: _imageUrlController,
                    hintText: 'URL da imagem',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a URL da imagem';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    isMultiline: true,
                    controller: _contentController,
                    hintText: 'Conteudo',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o conteudo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Button(
                      isLoading: isLoading,
                      text: 'Cadastrar',
                      onPressed: registerArticle),
                  const SizedBox(height: 15),
                  Button(
                      text: 'Cancelar',
                      backgroundColor: danger,
                      onPressed: () => Navigator.pop(context)),
                ]))
          ],
        ));
  }
}
