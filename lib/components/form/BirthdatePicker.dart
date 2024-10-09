import 'package:flutter/material.dart';

class BirthdatePicker extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const BirthdatePicker({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  _BirthdatePickerState createState() => _BirthdatePickerState();
}

class _BirthdatePickerState extends State<BirthdatePicker> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime.now();

    // Abre o DatePicker
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    // Se o usuário escolher uma data, atualiza o controlador
    if (picked != null && picked != initialDate) {
      setState(() {
        widget.controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: widget.controller,
      readOnly: true, // Não permite digitação manual
      onTap: () => _selectDate(context), // Abre o picker ao clicar no campo
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black12,
        hintText: 'Selecione sua data de nascimento',
        hintStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(
          Icons.calendar_today,
          color: Colors.white,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide.none,
        ),
      ),
      validator: widget.validator,
    );
  }
}
