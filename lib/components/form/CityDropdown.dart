import 'package:ecovitam/helpers/jwt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CityDropdown extends StatefulWidget {
  final String? selectedUF;
  final ValueChanged<String?> onChanged;

  const CityDropdown({
    super.key,
    this.selectedUF,
    required this.onChanged,
  });

  @override
  _CityDropdownState createState() => _CityDropdownState();
}

class _CityDropdownState extends State<CityDropdown> {
  String? selectedCity;
  List<String> cities = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedUF != null) {
      fetchCities(widget.selectedUF!);
    }
  }

  Future<void> fetchCities(String uf) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Uri.parse(
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados/$uf/distritos'));

    if (response.statusCode == 401) {
      await deleteToken();
      Navigator.pushReplacementNamed(context, '/login');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Seu login expirou, faça login novamente para continuar"),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      setState(() {
        cities = data.map((city) => city['nome'].toString()).toSet().toList()
          ..sort();
        isLoading = false;
      });
    } else {
      throw Exception('Falha ao carregar as cidades');
    }
  }

  @override
  void didUpdateWidget(covariant CityDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedUF != oldWidget.selectedUF &&
        widget.selectedUF != null) {
      setState(() {
        isLoading = true;
        selectedCity = null;
      });
      fetchCities(widget.selectedUF!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.white,
          ))
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
              fillColor:
                  widget.selectedUF == null ? Colors.white30 : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide.none,
              ),
              hintText: 'Selecione uma cidade',
            ),
          );
  }
}
