import 'package:ecovitam/constants/colors.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarDefault extends StatefulWidget {
  const BottomNavigationBarDefault({super.key});

  @override
  State<BottomNavigationBarDefault> createState() =>
      _BottomNavigationBarDefaultState();
}

class _BottomNavigationBarDefaultState
    extends State<BottomNavigationBarDefault> {
  // TODO - ajustar para pegar com base na rota
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
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
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/home');
              break;
            case 2:
              Navigator.pushNamed(context, '/home');
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
