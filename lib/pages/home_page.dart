import 'package:ecovitam/components/DefaultAppBar.dart';
import 'package:ecovitam/components/HomeInputFilter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _lastQueryCity = '';
  String? _lastQueryName = '';
  bool isLoading = false;
  bool hasError = false;

  Future<void> fetchList() async {
    setState(() {
      hasError = false;
      isLoading = true;
    });
    // Simulação de requisição API
    print("Requisição API com query: $_lastQueryCity  $_lastQueryName");

    final Uri url = Uri.parse(
        'http://10.0.2.2:3000/ponto-coleta?nome=$_lastQueryName&cidade=$_lastQueryCity');

    try {
      final response =
          await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        print('aqui $response');
      } else {
        hasError = true;
      }
    } catch (e) {
      setState(() {
        hasError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const DefaultAppBar(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(27),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 56, 67, 57),
          ),
          child: ListView(
            children: [
              HomeInputFilter(
                onChanged: (value) {
                  _lastQueryCity = value;
                  fetchList(); // Faz a requisição à API
                },
                hintText: 'Digite o nome',
              ),
              HomeInputFilter(
                onChanged: (value) {
                  _lastQueryName = value;
                  fetchList(); // Faz a requisição à API
                },
                hintText: 'Digite a cidade',
              ),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () => {},
                      child: const Text('Pontos de coleta')),
                  ElevatedButton(
                      onPressed: () => {}, child: const Text('Eventos'))
                ],
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ))
                  : const Column(
                      children: [],
                    )
            ],
          ),
        ));
  }
}
