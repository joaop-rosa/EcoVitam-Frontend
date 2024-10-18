import 'package:ecovitam/components/Button.dart';
import 'package:ecovitam/components/DefaultAppBar.dart';
import 'package:ecovitam/components/form/BirthdatePicker.dart';
import 'package:ecovitam/components/form/CityDropdown.dart';
import 'package:ecovitam/components/form/CustomTextFormField.dart';
import 'package:ecovitam/components/form/UfDropdown.dart';
import 'package:ecovitam/pages/home_page.dart';
import 'package:ecovitam/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController birthdateController = TextEditingController();

  String? selectedUF;
  String? selectedCity;

  bool isLoading = false;

  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Converte a data de nascimento para o formato aaaa-mm-dd
      String birthdate = '';
      try {
        DateTime date = DateFormat('d/M/yyyy').parse(birthdateController.text);
        birthdate = DateFormat('yyyy-MM-dd').format(date);
      } catch (e) {
        // Se a data for inválida, exibe uma mensagem de erro ou trata o erro adequadamente
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Formato de data inválido'),
        ));
        setState(() {
          isLoading = false;
        });
        return;
      }

      Map<String, String> body = {
        'email': emailController.text,
        'senha': base64Encode(
            utf8.encode(passwordController.text)), // Codifica a senha em Base64
        'primeiro_nome':
            nameController.text.split(' ').first, // Pega o primeiro nome
        'ultimo_nome':
            lastnameController.text.split(' ').last, // Pega o último nome
        'estado': selectedUF ?? '',
        'cidade': selectedCity ?? '',
        'data_nascimento': birthdate, // A data de nascimento
      };

      final Uri url = Uri.parse('http://10.0.2.2:3000/user');

      try {
        final response = await http.post(url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body));

        if (response.statusCode == 200) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
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
    return Scaffold(
      appBar: DefaultAppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(27),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 56, 67, 57),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextFormField(
                controller: emailController,
                hintText: 'E-mail',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um e-mail válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              CustomTextFormField(
                controller: nameController,
                hintText: 'Nome',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              CustomTextFormField(
                controller: lastnameController,
                hintText: 'Sobrenome',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu sobrenome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              CustomTextFormField(
                controller: passwordController,
                hintText: 'Senha',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma senha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              CustomTextFormField(
                controller: passwordConfirmController,
                hintText: 'Confirme a senha',
                obscureText: true,
                validator: (value) {
                  if (value != passwordController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              BirthdatePicker(
                controller: birthdateController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione sua data de nascimento';
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
              if (selectedUF != null)
                CityDropdown(
                  selectedUF: selectedUF!,
                  onChanged: (String? city) {
                    setState(() {
                      selectedCity = city;
                    });
                  },
                ),
              const SizedBox(height: 25),
              Button(
                isLoading: isLoading,
                text: 'Cadastrar',
                onPressed: registerUser,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Já tem uma conta?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                  TextButton(
                    child: const Text(
                      "Fazer login",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Color.fromRGBO(195, 255, 158, 1),
                          color: Color.fromRGBO(195, 255, 158, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
