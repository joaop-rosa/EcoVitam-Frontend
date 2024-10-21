import 'package:flutter/material.dart';

class TimePickerField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  const TimePickerField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black12,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide.none,
          ),
          suffixIcon: const Icon(
            Icons.access_time,
            color: Colors.white,
          )),
      onTap: () async {
        // Abre o TimePicker quando o ícone é pressionado
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          controller.text =
              '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}';
        }
      },
      validator: validator,
    );
  }
}
