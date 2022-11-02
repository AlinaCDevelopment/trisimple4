import 'package:app_4/models/innerView.dart';
import 'package:app_4/services/auth_service.dart';
import 'package:app_4/views/scan_view.dart';
import 'package:app_4/views/settings_view%20.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/colors.dart';
import 'auth_screen.dart';

class ContainerScreen extends StatefulWidget {
  const ContainerScreen({super.key});

  @override
  State<ContainerScreen> createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {
  var _selectedRouteName = 'scan';

  @override
  Widget build(BuildContext context) {
    var isPT = true;
    final screens = {
      'scan': ScanView(context),
      'settings': const SettingsView(),
    };

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Text(
                  'APP 4',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  'CONTROLO DE ACESSOS',
                  style: TextStyle(
                      fontSize: 12, color: Color.fromRGBO(150, 115, 250, 1)),
                ),
              ],
            ),
          ],
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: Padding(
              padding:
                  const EdgeInsets.only(left: 3.0, right: 5, top: 1, bottom: 1),
              child: Image.asset(
                  isPT ? 'assets/images/pt.png' : 'assets/images/en.png'),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, AuthScreen.routeName);
            },
          )
        ],
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/menu.png'),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 100,
                  child: DrawerHeader(
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.8)),
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                DrawerTile(
                    onTap: () {
                      setState(() {
                        _selectedRouteName = 'scan';
                      });
                    },
                    isSelected: 'scan' == _selectedRouteName,
                    title: 'SCAN'),
                Consumer(
                  builder: (context, ref, child) {
                    return DrawerTile(
                        onTap: () async {
                          ref.read(authProvider.notifier).resetAuth();
                          SystemChannels.platform
                              .invokeMethod('SystemNavigator.pop');
                        },
                        isSelected: false,
                        title: 'EXIT');
                  },
                ),
                DrawerTile(onTap: () {}, isSelected: false, title: 'HISTÓRICO'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 100),
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
            )
          ],
        ),
      ),
      body: screens[_selectedRouteName],
    );
  }
}

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    Key? key,
    required this.isSelected,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final bool isSelected;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: ListTile(
        title: Text(title),
        selectedColor: Colors.white,
        tileColor: Colors.grey.shade200,
        textColor: backColor,
        selectedTileColor: backColor,
        selected: isSelected,
        onTap: onTap,
        trailing: const Padding(
          padding: EdgeInsets.all(3.0),
          child: Icon(Icons.arrow_forward_ios_sharp),
        ),
      ),
    );
  }
}
