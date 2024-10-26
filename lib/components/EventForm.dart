import 'package:ecovitam/components/Button.dart';
import 'package:ecovitam/components/form/DatePicker.dart';
import 'package:ecovitam/components/form/CityDropdown.dart';
import 'package:ecovitam/components/form/CustomTextFormField.dart';
import 'package:ecovitam/components/form/PhoneField.dart';
import 'package:ecovitam/components/form/TimePickerField.dart';
import 'package:ecovitam/components/form/UfDropdown.dart';
import 'package:ecovitam/constants/colors.dart';
import 'package:ecovitam/helpers/jwt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class EventForm extends StatefulWidget {
  const EventForm({super.key});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>(); // Chave do formulário para validação
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _startHourController = TextEditingController();
  final TextEditingController _finalHourController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  bool isLoading = false;

  String? selectedUF;
  String? selectedCity;

  Future<void> registerEvent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      String date = '';
      try {
        DateTime dateTime = DateFormat('d/M/yyyy').parse(_dateController.text);
        date = DateFormat('yyyy-MM-dd').format(dateTime);
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

      // Converte a data de nascimento para o formato aaaa-mm-dd
      Map<String, String> body = {
        'titulo': _titleController.text,
        'endereco': _addressController.text, // Codifica a senha em Base64
        'estado': selectedUF ?? '',
        'cidade': selectedCity ?? '',
        'contato': _contactController.text,
        'data': date,
        'horaInicio': _startHourController.text,
        'horaFim': _finalHourController.text // A data de nascimento
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

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Cadastrado com sucesso'),
          ));
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Erro ao registrar: ${response.body}'),
          ));
          print(response.body);
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
            controller: _titleController,
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
          const SizedBox(height: 15),
          DatePicker(
            controller: _dateController,
            hintText: 'Data do evento',
            canBeInFuture: true,
          ),
          const SizedBox(height: 15),
          TimePickerField(
              controller: _startHourController, hintText: 'Hora início'),
          const SizedBox(height: 15),
          TimePickerField(
              controller: _finalHourController, hintText: 'Hora Fim'),
          const SizedBox(height: 25),
          Button(
              isLoading: isLoading,
              text: 'Cadastrar',
              onPressed: registerEvent),
          const SizedBox(height: 15),
          Button(
              text: 'Cancelar',
              backgroundColor: danger,
              onPressed: () => Navigator.pop(context)),
        ]));
  }
}
