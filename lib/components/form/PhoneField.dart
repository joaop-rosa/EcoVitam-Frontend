import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:flutter/material.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  const PhoneField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    String initialCountry = 'BR';
    PhoneNumber? number = PhoneNumber(isoCode: initialCountry);

    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {},
      onInputValidated: (bool value) {},
      onSaved: (PhoneNumber number) {},
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        useBottomSheetSafeArea: true,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.disabled,
      selectorTextStyle: const TextStyle(color: Colors.white),
      validator: validator,
      countries: const ['BR'],
      initialValue: number,
      textFieldController: controller,
      formatInput: true,
      keyboardType:
          const TextInputType.numberWithOptions(signed: true, decimal: true),
      inputBorder: const OutlineInputBorder(),
      inputDecoration: InputDecoration(
        filled: true,
        fillColor: Colors.black12,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
