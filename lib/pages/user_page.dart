import 'package:ecovitam/components/BottomNavigationBarDefault.dart';
import 'package:ecovitam/components/Button.dart';
import 'package:ecovitam/components/CollectionPointItem.dart';
import 'package:ecovitam/components/DefaultAppBar.dart';
import 'package:ecovitam/components/EventItem.dart';
import 'package:ecovitam/constants/colors.dart';
import 'package:ecovitam/helpers/jwt.dart';
import 'package:ecovitam/models/CollectionPoint.dart';
import 'package:ecovitam/models/Events.dart';
import 'package:ecovitam/models/User.dart';
import 'package:ecovitam/presenter/CollectionPointItemPresenter.dart';
import 'package:ecovitam/presenter/EventItemPresenter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool isLoading = false;
  bool hasError = false;
  List<CollectionPoint> collectionPoints = [];
  List<Event> events = [];
  String selectedButton = 'collectionPoint';
  User? user;

  Future<void> fetchList() async {
    setState(() {
      hasError = false;
      isLoading = true;
    });

    final Uri url = (selectedButton == 'collectionPoint')
        ? Uri.parse('http://10.0.2.2:3000/meus-pontos-coleta')
        : Uri.parse('http://10.0.2.2:3000/meus-eventos');

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

  Future<void> initializeData() async {
    final token = await getToken();
    if (token != null) {
      setState(() {
        final decodedToken = JwtDecoder.decode(token);
        user = User.fromJson(jsonDecode(decodedToken['user']));
      });
    }

    fetchList();
  }

  @override
  void initState() {
    super.initState();
    initializeData();
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
            CollectionPointItemPresenter collectionPointItemPresenter =
                CollectionPointItemPresenter();

            final collectionPoint = collectionPoints[index];
            return Column(children: [
              CollectionPointItem(
                  colletionPoint: collectionPoint,
                  presenter: collectionPointItemPresenter,
                  isUserOwn: true),
              const SizedBox(height: 15)
            ]);
          });
    }

    if (selectedButton == 'events' && events.isNotEmpty) {
      return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            EventItemPresenter eventItemPresenter = EventItemPresenter();
            final event = events[index];
            return Column(children: [
              EventItem(
                event: event,
                presenter: eventItemPresenter,
                isUserOwn: true,
              ),
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
          child: Column(
            children: [
              user != null
                  ? Column(children: [
                      Text(
                        'Nome: ${user?.nome}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text(
                        'Cidade: ${user?.cidade} - ${user?.estado}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      )
                    ])
                  : const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedButton = 'collectionPoint';
                              fetchList();
                            });
                          },
                          style: selectedButton == 'collectionPoint'
                              ? ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(primary),
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
                          onPressed: () {
                            setState(() {
                              selectedButton = 'events';
                              fetchList();
                            });
                          },
                          style: selectedButton == 'events'
                              ? ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(primary),
                                )
                              : const ButtonStyle(),
                          child: const Text(
                            'Eventos',
                            style: TextStyle(
                                color: Color.fromRGBO(7, 7, 7, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ))),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: renderList(),
              ),
              const SizedBox(height: 20),
              Button(
                text: 'Logout',
                onPressed: () async {
                  await deleteToken();
                  Navigator.pushReplacementNamed(context, '/');
                },
                backgroundColor: danger,
              )
            ],
          ),
        ));
  }
}
