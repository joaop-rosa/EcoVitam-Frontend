import 'dart:convert'; // Para codificação Base64
import 'package:ecovitam/components/Button.dart';
import 'package:ecovitam/components/form/CustomTextFormField.dart';
import 'package:ecovitam/constants/colors.dart';
import 'package:ecovitam/helpers/jwt.dart';
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
  bool isAutoLoginLoading = true;

  Future<void> _autoLogin() async {
    final authToken = await getToken();
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/check-token'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $authToken'
        },
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } finally {
      setState(() {
        isAutoLoginLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

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

    String basicAuth = 'Basic ${base64Encode(utf8.encode('$email:$password'))}';

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/login'),
        headers: {
          'Authorization': basicAuth,
          'Content-Type': 'application/json',
        },
      );

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
      }
    } catch (e) {
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
      body: isAutoLoginLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(27),
              decoration: const BoxDecoration(
                color: background,
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
                          obscureText: true,
                        ),
                        const SizedBox(height: 30),
                        Button(
                          isLoading: isLoading,
                          text: 'Acessar',
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
                              decorationColor: primary,
                              color: primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w800),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
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
