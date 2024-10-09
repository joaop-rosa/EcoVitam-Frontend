import 'dart:convert'; // Para codificação Base64
import 'package:ecovitam/components/Button.dart';
import 'package:ecovitam/components/form/CustomTextFormField.dart';
import 'package:ecovitam/pages/home_page.dart';
import 'package:ecovitam/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    final String email = emailController.text.trim();
    final String password =
        base64Encode(utf8.encode(passwordController.text.trim()));

    // Codificação dos dados para Basic Auth
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$email:$password'))}';

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/login'), // Substitua pelo endpoint real
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Se o login for bem-sucedido, navegue para a HomePage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Login falhou. Verifique suas credenciais.')),
        );
      }
    } catch (e) {
      print('Erro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Ocorreu um erro. Tente novamente mais tarde.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(27),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 56, 67, 57),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Image(
              image: AssetImage('assets/images/logo.png'),
              width: 140,
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: emailController,
                    hintText: 'Digite o seu e-mail',
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    controller: passwordController,
                    hintText: 'Digite sua senha',
                    obscureText: true, // Especifica que o texto deve ser oculto
                  ),
                  const SizedBox(height: 30),
                  Button(
                    isLoading: isLoading, // Estado de carregamento
                    text: 'Acessar', // Texto do botão
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _login();
                      }
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Não tem uma conta?',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
                TextButton(
                  child: const Text(
                    "Cadastre-se",
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
                          builder: (context) => const RegisterPage()),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
