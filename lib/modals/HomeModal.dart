import 'package:ecovitam/components/CollectionPointForm.dart';
import 'package:ecovitam/components/EventForm.dart';
import 'package:ecovitam/constants/colors.dart';
import 'package:flutter/material.dart';

class HomeModal extends StatefulWidget {
  const HomeModal({super.key});

  @override
  _HomeModalState createState() => _HomeModalState();
}

class _HomeModalState extends State<HomeModal> {
  String? _selectedValue = 'collectionPoint';

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio<String>(
                      activeColor: Colors.white,
                      fillColor: const WidgetStatePropertyAll(Colors.white),
                      value: 'collectionPoint',
                      groupValue: _selectedValue,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedValue = value;
                        });
                      },
                    ),
                    const Text(
                      'Ponto de coleta',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio<String>(
                      activeColor: Colors.white,
                      fillColor: const WidgetStatePropertyAll(Colors.white),
                      value: 'events',
                      groupValue: _selectedValue,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedValue = value;
                        });
                      },
                    ),
                    const Text('Eventos',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 15),
            if (_selectedValue == 'collectionPoint')
              const CollectionPointForm(),
            if (_selectedValue == 'events') const EventForm()
          ],
        )));
  }
}
