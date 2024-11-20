import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasArrowBack;

  const DefaultAppBar({
    super.key,
    this.hasArrowBack = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 56, 67, 57),
      automaticallyImplyLeading: hasArrowBack,
      leading: hasArrowBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            )
          : null,
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
    );
  }
}
