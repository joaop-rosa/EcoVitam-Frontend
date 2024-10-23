import 'package:ecovitam/constants/colors.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarDefault extends StatefulWidget {
  const BottomNavigationBarDefault({super.key});

  @override
  State<BottomNavigationBarDefault> createState() =>
      _BottomNavigationBarDefaultState();
}

int getCurrentPageIndex(BuildContext context) {
  // Obtém o nome da rota atual
  String? currentRoute = ModalRoute.of(context)?.settings.name;

  // Mapeia as rotas para índices de página
  switch (currentRoute) {
    case '/article':
      return 0;
    case '/home':
      return 1;
    case '/user':
      return 2;
    default:
      return 0; // Valor padrão se a rota não for reconhecida
  }
}

class _BottomNavigationBarDefaultState
    extends State<BottomNavigationBarDefault> {
  @override
  Widget build(BuildContext context) {
    int currentPageIndex = getCurrentPageIndex(context);

    return NavigationBar(
      backgroundColor: bottomNavigatorBackground,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      indicatorColor: const Color.fromARGB(0, 0, 0, 0),
      selectedIndex: currentPageIndex,
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/article');
              break;
            case 1:
              Navigator.pushNamed(context, '/home');
              break;
            case 2:
              Navigator.pushNamed(context, '/user');
              break;
            default:
          }
        });
      },
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.newspaper),
          label: 'Artigos',
          selectedIcon: Icon(
            Icons.newspaper,
            color: primary,
          ),
        ),
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Home',
          selectedIcon: Icon(
            Icons.home,
            color: primary,
          ),
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: 'Perfil',
          selectedIcon: Icon(
            Icons.person,
            color: primary,
          ),
        )
      ],
    );
  }
}
