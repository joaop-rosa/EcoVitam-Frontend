import 'package:ecovitam/components/Button.dart';
import 'package:ecovitam/components/DefaultAppBar.dart';
import 'package:ecovitam/components/form/DatePicker.dart';
import 'package:ecovitam/components/form/CityDropdown.dart';
import 'package:ecovitam/components/form/CustomTextFormField.dart';
import 'package:ecovitam/components/form/UfDropdown.dart';
import 'package:ecovitam/presenter/RegisterPagePresenter.dart';
import 'package:ecovitam/view/RegisterView.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> implements RegisterView {
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

  late RegisterPagePresenter presenter;

  @override
  void initState() {
    super.initState();
    presenter = RegisterPagePresenter(this);
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

  void onSubmit() async {
    if (_formKey.currentState!.validate()) {
      presenter.registerUser(
          context,
          birthdateController.text,
          emailController.text,
          passwordController.text,
          nameController.text,
          lastnameController.text,
          selectedUF!,
          selectedCity!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(),
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
              DatePicker(
                controller: birthdateController,
                hintText: 'Selecione sua data de nascimento',
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
              CityDropdown(
                selectedUF: selectedUF,
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
                onPressed: onSubmit,
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
                      Navigator.pushNamed(context, '/');
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
