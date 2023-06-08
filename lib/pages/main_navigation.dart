import 'package:encrypt_decrypt_app/pages/decrypt_page.dart';
import 'package:encrypt_decrypt_app/pages/encrypt_page.dart';
import 'package:flutter/material.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: selectedIndex,
      child: Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: const [
            EncryptPage(),
            DecryptPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey[500],
          onTap: (index) {
            selectedIndex = index;
            setState(() {});
          },
          items: const [
            BottomNavigationBarItem(
              label: "Encrypt",
              icon: Icon(
                Icons.lock_open_outlined,
              ),
            ),
            BottomNavigationBarItem(
              label: "Decrypt",
              icon: Icon(
                Icons.lock_open,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
