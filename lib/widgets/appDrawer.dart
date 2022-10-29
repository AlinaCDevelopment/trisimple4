import 'package:app_4/constants/colors.dart';
import 'package:app_4/screens/scan_screen.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({required this.selectedRouteName, super.key});

  final String selectedRouteName;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  List<bool> tilesSelected = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.8)),
              padding: EdgeInsets.only(left: 10),
              margin: null,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 200,
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 70,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'APP4\nCONTROLO DE ACESSOS',
                        style: TextStyle(
                            color: backColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      Text(
                        'Festival Mais Solidário',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DrawerTile(
              routeName: ScanScreen.routeName,
              isSelected: ScanScreen.routeName == widget.selectedRouteName,
              title: 'SCAN TAG BY NFC'),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Contato responsável técnico\n do evento para pedido de suporte:',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  Text(
                    '+351 962 260 499',
                    style: TextStyle(
                        color: backColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'www.trisimple.pt',
                    style: TextStyle(
                        color: backColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    Key? key,
    required this.isSelected,
    required this.title,
    required this.routeName,
  }) : super(key: key);

  final bool isSelected;
  final String title;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      selectedColor: Colors.white,
      tileColor: Colors.white,
      textColor: backColor,
      selectedTileColor: backColor,
      selected: isSelected,
      onTap: () {
        Navigator.pushReplacementNamed(context, routeName);
      },
    );
  }
}
