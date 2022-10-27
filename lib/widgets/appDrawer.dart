import 'package:app_4/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

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
                  Container(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 200,
                      height: 100,
                    ),
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
                    children: [
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
          ListTile(
            title: const Text('SCAN TAG BY NFC'),
            selectedColor: backColor,
            tileColor: Colors.black,
            selectedTileColor: backColor,
            selected: tilesSelected[0],
            onTap: () {
              // tilesSelected.setAll(0, [false]);
              //TODO Go to Scan
            },
          ),
          ListTile(
            title: const Text('SCAN TAG BY NFC'),
            selectedColor: backColor,
            tileColor: Colors.black,
            selectedTileColor: backColor,
            selected: tilesSelected[0],
            onTap: () {
              // tilesSelected.setAll(0, [false]);
              //TODO Go to SETTING
            },
          ),
          ListTile(
            title: const Text('SCAN TAG BY NFC'),
            selectedColor: backColor,
            tileColor: Colors.black,
            selectedTileColor: backColor,
            selected: tilesSelected[0],
            onTap: () {
              // tilesSelected.setAll(0, [false]);
              //TODO Go to Scan
            },
          ),
          ListTile(
            title: const Text('SCAN TAG BY NFC'),
            selectedColor: backColor,
            tileColor: Colors.black,
            selectedTileColor: backColor,
            selected: tilesSelected[0],
            onTap: () {
              // tilesSelected.setAll(0, [false]);
              //TODO Go to Scan
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
