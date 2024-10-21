import 'package:ecovitam/components/Button.dart';
import 'package:ecovitam/components/form/CityDropdown.dart';
import 'package:ecovitam/components/form/CustomTextFormField.dart';
import 'package:ecovitam/components/form/UfDropdown.dart';
import 'package:ecovitam/constants/colors.dart';
import 'package:flutter/material.dart';

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
