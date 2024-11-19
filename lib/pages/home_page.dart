import 'package:ecovitam/components/BottomNavigationBarDefault.dart';
import 'package:ecovitam/components/CollectionPointItem.dart';
import 'package:ecovitam/components/DefaultAppBar.dart';
import 'package:ecovitam/components/EventItem.dart';
import 'package:ecovitam/components/HomeInputFilter.dart';
import 'package:ecovitam/constants/colors.dart';
import 'package:ecovitam/modals/HomeModal.dart';
import 'package:ecovitam/models/CollectionPoint.dart';
import 'package:ecovitam/models/Events.dart';
import 'package:ecovitam/presenter/CollectionPointItemPresenter.dart';
import 'package:ecovitam/presenter/HomePresenter.dart';
import 'package:ecovitam/view/HomeView.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements HomeView {
  bool isLoading = false;
  bool hasError = false;
  String selectedButton = 'collectionPoint';
  List<CollectionPoint> collectionPoints = [];
  List<Event> events = [];

  late HomePresenter presenter;

  @override
  void initState() {
    super.initState();
    presenter = HomePresenter(this);
  }

  @override
  void showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  @override
  void hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  void showError() {
    setState(() {
      hasError = true;
    });
  }

  @override
  void hideError() {
    setState(() {
      hasError = false;
    });
  }

  @override
  void setButtonActive(String buttonName) {
    setState(() {
      selectedButton = buttonName;
    });
  }

  @override
  void setCollectionPoints(List<CollectionPoint> collectionPoints) {
    setState(() {
      this.collectionPoints = collectionPoints;
    });
  }

  @override
  void setEvents(List<Event> events) {
    setState(() {
      this.events = events;
    });
  }

  void selectedButtonTap(String selectedButtonName) {
    setState(() {
      String oldState = selectedButton;
      selectedButton = selectedButtonName;
      if (selectedButton != oldState) {
        presenter.fetchList(selectedButton);
      }
    });
  }

  Widget renderList() {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.white),
      ));
    }

    if (selectedButton == 'collectionPoint' && collectionPoints.isNotEmpty) {
      CollectionPointItemPresenter collectionPointItemPresenter =
          CollectionPointItemPresenter();

      return ListView.builder(
          itemCount: collectionPoints.length,
          itemBuilder: (context, index) {
            final collectionPoint = collectionPoints[index];
            return Column(children: [
              CollectionPointItem(
                colletionPoint: collectionPoint,
                presenter: collectionPointItemPresenter,
              ),
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
                      presenter.lastQueryCity = value;
                      presenter.fetchList(selectedButton);
                    },
                    hintText: 'Busque pela cidade',
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  HomeInputFilter(
                    onChanged: (value) {
                      presenter.lastQueryName = value;
                      presenter.fetchList(selectedButton);
                    },
                    hintText: 'Busque pelo nome',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () =>
                                  selectedButtonTap('collectionPoint'),
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
                              onPressed: () => selectedButtonTap('events'),
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
                        return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: const HomeModal());
                      },
                    );

                    if (result == true) {
                      presenter.fetchList(selectedButton);
                    }
                  },
                  icon: const Icon(
                    Icons.add,
                  ),
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(primary),
                    minimumSize: WidgetStatePropertyAll(Size(52, 52)),
                  ),
                ),
              )
            ])));
  }
}
