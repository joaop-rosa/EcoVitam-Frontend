import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 56, 67, 57),
          title: Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16),
            child: Row(
              children: [
                const Spacer(),
                Image.asset(
                  'assets/images/logo.png',
                  height: 60,
                ),
              ],
            ),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(27),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 56, 67, 57),
          ),
        ));
  }
}
