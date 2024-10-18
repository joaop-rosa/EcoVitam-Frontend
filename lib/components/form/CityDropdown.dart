import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CityDropdown extends StatefulWidget {
  final String selectedUF;
  final ValueChanged<String?> onChanged;

  const CityDropdown({
    super.key,
    required this.selectedUF,
    required this.onChanged,
  });

  @override
  _CityDropdownState createState() => _CityDropdownState();
}

class _CityDropdownState extends State<CityDropdown> {
  String? selectedCity;
  List<String> cities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCities(widget.selectedUF);
  }

  Future<void> fetchCities(String uf) async {
    final response = await http.get(Uri.parse(
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados/$uf/distritos')); // URL da API para cidades

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      setState(() {
        cities = data.map((city) => city['nome'].toString()).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Falha ao carregar as cidades');
    }
  }

  @override
  void didUpdateWidget(covariant CityDropdown oldWidget) {
    super.didUpdateWidget(
        oldWidget); // Certifique-se de chamar o método da superclasse
    if (widget.selectedUF != oldWidget.selectedUF) {
      setState(() {
        isLoading = true;
        selectedCity = null; // Limpa a cidade ao trocar o estado
      });
      fetchCities(widget.selectedUF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : DropdownButtonFormField<String>(
            value: selectedCity,
            onChanged: (String? newValue) {
              setState(() {
                selectedCity = newValue;
              });
              widget.onChanged(newValue);
            },
            items: cities.map<DropdownMenuItem<String>>((String city) {
              return DropdownMenuItem<String>(
                value: city,
                child: Text(city),
              );
            }).toList(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide.none,
              ),
              hintText: 'Selecione uma cidade',
            ),
          );
  }
}
