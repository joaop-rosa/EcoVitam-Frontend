import 'package:ecovitam/components/Button.dart';
import 'package:ecovitam/components/form/CityDropdown.dart';
import 'package:ecovitam/components/form/CustomTextFormField.dart';
import 'package:ecovitam/components/form/PhoneField.dart';
import 'package:ecovitam/components/form/UfDropdown.dart';
import 'package:ecovitam/constants/colors.dart';
import 'package:ecovitam/helpers/jwt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CollectionPointForm extends StatefulWidget {
  const CollectionPointForm({super.key});

  @override
  State<CollectionPointForm> createState() => _CollectionPointFormState();
}

class _CollectionPointFormState extends State<CollectionPointForm> {
  final _formKey = GlobalKey<FormState>(); // Chave do formulário para validação
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  bool isLoading = false;

  String? selectedUF;
  String? selectedCity;

  Future<void> registerCollectionPoint() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Converte a data de nascimento para o formato aaaa-mm-dd
      Map<String, String> body = {
        'nome': _nameController.text,
        'endereco': _addressController.text, // Codifica a senha em Base64
        'estado': selectedUF ?? '',
        'cidade': selectedCity ?? '',
        'contato': _contactController.text, // A data de nascimento
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
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          CustomTextFormField(
            controller: _nameController,
            hintText: 'Nome',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o nome do ponto de coleta';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          CustomTextFormField(
            controller: _addressController,
            hintText: 'Endereço',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o endereço do ponto de coleta';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          UFDropdown(
            onChanged: (String? uf) {
              setState(() {
                selectedUF = uf;
              });
            },
          ),
          const SizedBox(height: 15),
          CityDropdown(
            selectedUF: selectedUF,
            onChanged: (String? city) {
              setState(() {
                selectedCity = city;
              });
            },
          ),
          const SizedBox(height: 15),
          PhoneField(
              controller: _contactController,
              hintText: 'Contato',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o contato do ponto de coleta';
                }
                return null;
              }),
          const SizedBox(height: 25),
          Button(
              isLoading: isLoading,
              text: 'Cadastrar',
              onPressed: registerCollectionPoint),
          const SizedBox(height: 15),
          Button(
              text: 'Cancelar',
              backgroundColor: danger,
              onPressed: () => Navigator.pop(context)),
        ]));
  }
}
