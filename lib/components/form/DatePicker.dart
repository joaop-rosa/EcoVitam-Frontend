import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hintText;
  final bool canBeInFuture;

  const DatePicker({
    super.key,
    required this.controller,
    required this.hintText,
    this.canBeInFuture = false,
    this.validator,
  });

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime.now();

    if (widget.canBeInFuture) {
      lastDate = DateTime.now()
          .add(const Duration(days: 730)); // Última data daqui a 1 ano
    }

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
        hintText: widget.hintText,
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
