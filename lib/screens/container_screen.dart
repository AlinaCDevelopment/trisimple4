import 'package:app_4/models/innerView.dart';
import 'package:app_4/providers/auth_provider.dart';
import 'package:app_4/providers/locale_provider.dart';
import 'package:app_4/views/scan_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/assets_routes.dart';
import '../constants/colors.dart';
import 'auth_screen.dart';

class ContainerScreen extends StatefulWidget {
  const ContainerScreen({super.key, required this.title});
  final String title;

  @override
  State<ContainerScreen> createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {
  var _selectedRouteName = 'scan';

  @override
  Widget build(BuildContext context) {
    final screens = {
      'scan': ScanView(context),
    };

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'APP 4',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AppLocalizations.of(context)!.controlAccess,
                    style: const TextStyle(
                        fontSize: 12, color: Color.fromRGBO(150, 115, 250, 1)),
                  ),
                ],
              ),
            ],
          ),
          titleSpacing: 0,
          actions: [
            Consumer(builder: (context, ref, _) {
              final isPt = ref.read(localeProvider).languageCode == 'pt';
              return IconButton(
                icon: Padding(
                  padding: const EdgeInsets.only(
                      left: 3.0, right: 5, top: 1, bottom: 1),
                  child: Image.asset(isPt ? ptImgRoute : enImgRoute),
                ),
                onPressed: () {
                  print('pop');
                  ref
                      .read(localeProvider.notifier)
                      .setLocale(isPt ? 'en' : 'pt');
                },
              );
            })
          ],
          leading: Builder(builder: (context) {
            return IconButton(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(menuImgRoute),
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
                      padding: const EdgeInsets.only(left: 10),
                      margin: null,
                      child: Row(
                        children: [
                          Image.asset(
                            logoImageRoute,
                            width: 200,
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 20.0),
                    child: Row(
                      children: [
                        /*  Container(
                          height: 100,
                          width: 70,
                          color: Colors.grey,
                        ), */
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'APP4\n${AppLocalizations.of(context)!.controlAccess}',
                                style: const TextStyle(
                                    color: backMaterialColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              Text(
                                widget.title,
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
                    title: AppLocalizations.of(context)!.scan,
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      return DrawerTile(
                        onTap: () async {
                          ref.read(authProvider.notifier).resetAuth();
                          /*   Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AuthScreen()),
                          ); */
                          SystemChannels.platform
                              .invokeMethod('SystemNavigator.pop');
                        },
                        isSelected: false,
                        title: AppLocalizations.of(context)!.exit,
                      );
                    },
                  ),
                  /* DrawerTile(
                      onTap: () {}, isSelected: false, title: 'HISTÓRICO'), */
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.contactsLabel,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const Text(
                      '+351 962 260 499',
                      style: TextStyle(
                          color: backMaterialColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'www.trisimple.pt',
                      style: TextStyle(
                          color: backMaterialColor,
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
      ),
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
        textColor: backMaterialColor,
        selectedTileColor: backMaterialColor,
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
