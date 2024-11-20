import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UFDropdown extends StatefulWidget {
  final ValueChanged<String?> onChanged;

  const UFDropdown({
    super.key,
    required this.onChanged,
  });

  @override
  _UFDropdownState createState() => _UFDropdownState();
}

class _UFDropdownState extends State<UFDropdown> {
  String? selectedUF;
  List<String> ufs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUFs();
  }

  Future<void> fetchUFs() async {
    final response = await http.get(Uri.parse(
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      setState(() {
        ufs = data.map((uf) => uf['sigla'].toString()).toSet().toList()..sort();
        isLoading = false;
      });
    } else {
      throw Exception('Falha ao carregar os estados');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : DropdownButtonFormField<String>(
            value: selectedUF,
            onChanged: (String? newValue) {
              setState(() {
                selectedUF = newValue;
              });
              widget.onChanged(newValue);
            },
            items: ufs.map<DropdownMenuItem<String>>((String uf) {
              return DropdownMenuItem<String>(
                value: uf,
                child: Text(uf),
              );
            }).toList(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide.none,
              ),
              hintText: 'Selecione um estado',
            ),
          );
  }
}
