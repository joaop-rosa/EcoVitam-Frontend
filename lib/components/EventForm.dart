import 'package:ecovitam/components/Button.dart';
import 'package:ecovitam/components/form/CityDropdown.dart';
import 'package:ecovitam/components/form/CustomTextFormField.dart';
import 'package:ecovitam/components/form/TimePickerField.dart';
import 'package:ecovitam/components/form/UfDropdown.dart';
import 'package:ecovitam/constants/colors.dart';
import 'package:flutter/material.dart';

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

  bool isLoading = false;

  String? selectedUF;
  String? selectedCity;

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
          CustomTextFormField(
            controller: _contactController,
            hintText: 'Contato',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o contato do ponto de coleta';
              }
              return null;
            },
          ),
          const SizedBox(height: 15),
          TimePickerField(
              controller: _startHourController, hintText: 'Hora início'),
          const SizedBox(height: 15),
          TimePickerField(
              controller: _finalHourController, hintText: 'Hora Fim'),
          const SizedBox(height: 25),
          Button(isLoading: isLoading, text: 'Cadastrar', onPressed: () => {}),
          const SizedBox(height: 15),
          Button(
              isLoading: isLoading,
              text: 'Cancelar',
              backgroundColor: danger,
              onPressed: () => Navigator.pop(context)),
        ]));
  }
}
