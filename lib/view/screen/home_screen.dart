import 'package:flutter/material.dart';
import 'package:tiktok_clone/constans.dart';
import 'package:tiktok_clone/view/widgets/custom_icon.dart';
import 'package:tiktok_clone/view/widgets/icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Color backgroundColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
        ),
        child: Container(
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(width: 0.2,color: Colors.white38))),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor:
                _selectedIndex == 0 ? Colors.white : Colors.black,
            unselectedItemColor:
                _selectedIndex == 0 ? Colors.white54 : Colors.black54,
            backgroundColor: backgroundColor,
            selectedFontSize: 12,
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(TikTokIcons.home), label: 'Beranda'),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_outlined), label: 'Shop'),
              BottomNavigationBarItem(
                icon: CustomIcon(
                  backgroundColor:
                      _selectedIndex == 0 ? Colors.white : Colors.black,
                  iconColor: _selectedIndex != 0 ? Colors.white : Colors.black,
                ),
                label: '',
              ),
              const BottomNavigationBarItem(
                  icon: Icon(TikTokIcons.messages), label: 'Kotak masuk'),
              const BottomNavigationBarItem(
                  icon: Icon(TikTokIcons.profile), label: 'Profil')
            ],
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                if (_selectedIndex == 0) {
                  backgroundColor = Colors.black;
                } else {
                  backgroundColor = Colors.white;
                }
              });
            },
          ),
        ),
      ),
      body: pages[_selectedIndex],
    );
  }
}
