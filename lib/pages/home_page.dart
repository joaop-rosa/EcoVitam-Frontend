import 'dart:convert';
import 'package:ecovitam/components/BottomNavigationBarDefault.dart';
import 'package:ecovitam/components/CollectionPointItem.dart';
import 'package:ecovitam/components/DefaultAppBar.dart';
import 'package:ecovitam/components/EventItem.dart';
import 'package:ecovitam/components/HomeInputFilter.dart';
import 'package:ecovitam/constants/colors.dart';
import 'package:ecovitam/helpers/jwt.dart';
import 'package:ecovitam/modals/HomeModal.dart';
import 'package:ecovitam/models/CollectionPoint.dart';
import 'package:ecovitam/models/Events.dart';
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
  List<CollectionPoint> collectionPoints = [];
  List<Event> events = [];
  String selectedButton = 'collectionPoint';

  Future<void> fetchList() async {
    setState(() {
      hasError = false;
      isLoading = true;
    });

    final Uri url = (selectedButton == 'collectionPoint')
        ? Uri.parse(
            'http://10.0.2.2:3000/ponto-coleta?nome=$_lastQueryName&cidade=$_lastQueryCity')
        : Uri.parse(
            'http://10.0.2.2:3000/eventos?nome=$_lastQueryName&cidade=$_lastQueryCity');

    final authToken = await getToken();
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $authToken'
      });

      if (response.statusCode == 200) {
        List<dynamic> jsonArray = json.decode(response.body);

        if (selectedButton == 'collectionPoint') {
          List<CollectionPoint> collectionPointsResponse =
              jsonArray.map((jsonItem) {
            return CollectionPoint.fromJson(jsonItem);
          }).toList();

          setState(() {
            collectionPoints = collectionPointsResponse;
          });
        } else {
          List<Event> eventsResponse = jsonArray.map((jsonItem) {
            return Event.fromJson(jsonItem);
          }).toList();

          setState(() {
            events = eventsResponse;
          });
        }
      } else {
        setState(() {
          hasError = true;
        });
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

  Widget renderList() {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.white),
      ));
    }

    if (selectedButton == 'collectionPoint' && collectionPoints.isNotEmpty) {
      return ListView.builder(
          itemCount: collectionPoints.length,
          itemBuilder: (context, index) {
            final collectionPoint = collectionPoints[index];
            return Column(children: [
              CollectionPointItem(
                  pontoColetaNome: collectionPoint.pontoColetaNome,
                  cidade: collectionPoint.cidade,
                  contato: collectionPoint.contato,
                  endereco: collectionPoint.endereco,
                  estado: collectionPoint.estado,
                  nomeCompleto: collectionPoint.nomeCompleto),
              const SizedBox(height: 15)
            ]);
          });
    }

    if (selectedButton == 'events' && events.isNotEmpty) {
      return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return Column(children: [
              EventItem(
                  titulo: event.titulo,
                  cidade: event.cidade,
                  contato: event.contato,
                  endereco: event.endereco,
                  estado: event.estado,
                  data: event.data,
                  horaFim: event.horaFim,
                  horaInicio: event.horaInicio,
                  nomeCompleto: event.nomeCompleto),
              const SizedBox(height: 15)
            ]);
          });
    }

    return const Text(
      'Não encontramos resultados para sua pesquisa',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const DefaultAppBar(
          hasArrowBack: false,
        ),
        bottomNavigationBar: const BottomNavigationBarDefault(),
        body: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(27),
            decoration: const BoxDecoration(
              color: background,
            ),
            child: Stack(children: [
              Column(
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () => {
                                    setState(() {
                                      String oldState = selectedButton;
                                      selectedButton = 'collectionPoint';
                                      if (selectedButton != oldState) {
                                        fetchList();
                                      }
                                    })
                                  },
                              style: selectedButton == 'collectionPoint'
                                  ? const ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll(primary),
                                    )
                                  : const ButtonStyle(),
                              child: const Text(
                                'Pontos de coleta',
                                style: TextStyle(
                                    color: Color.fromRGBO(7, 7, 7, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ))),
                      const SizedBox(width: 16),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () => {
                                    setState(() {
                                      String oldState = selectedButton;
                                      selectedButton = 'events';
                                      if (selectedButton != oldState) {
                                        fetchList();
                                      }
                                    })
                                  },
                              style: selectedButton == 'events'
                                  ? const ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll(primary))
                                  : const ButtonStyle(),
                              child: const Text('Eventos',
                                  style: TextStyle(
                                      color: Color.fromRGBO(7, 7, 7, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)))),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: renderList(),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                  onPressed: () async {
                    final result = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return const HomeModal();
                      },
                    );

                    if (result == true) {
                      fetchList(); // Recarrega os dados
                    }
                  },
                  icon: const Icon(
                    Icons.add,
                  ),
                  // Para definir o fundo e o tamanho do ícone:
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(primary),
                    minimumSize: WidgetStatePropertyAll(Size(52, 52)),
                  ),
                ),
              )
            ])));
  }
}
