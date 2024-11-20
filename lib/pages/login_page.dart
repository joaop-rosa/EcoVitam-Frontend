import 'package:ecovitam/components/Button.dart';
import 'package:ecovitam/components/form/CustomTextFormField.dart';
import 'package:ecovitam/constants/colors.dart';
import 'package:ecovitam/presenter/AuthPresenter.dart';

import 'package:ecovitam/presenter/LoginPagePresenter.dart';
import 'package:ecovitam/view/LoginView.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginView {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isAutoLoginLoading = true;

  late LoginPagePresenter presenter;
  late AuthPresenter authPresenter;

  @override
  void initState() {
    super.initState();
    presenter = LoginPagePresenter(this);
    authPresenter = AuthPresenter(this);
    presenter.autoLogin(context);
  }

  @override
  void hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  void showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  @override
  void hideAutoLoginLoading() {
    setState(() {
      isAutoLoginLoading = false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                              authPresenter.login(
                                  context,
                                  emailController.text.trim(),
                                  passwordController.text.trim());
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
