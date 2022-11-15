import 'dart:io';

import 'package:app_4/helpers/size_helper.dart';
import 'package:app_4/services/internal_storage_service.dart';
import 'package:app_4/views/pending_view.dart';
import 'package:app_4/views/search_view.dart';

import '../models/innerView.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../services/database_service.dart';
import '../views/scan_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/assets_routes.dart';
import '../constants/colors.dart';
import '../widgets/ui/views_container.dart';
import 'auth_screen.dart';

@immutable
class ViewNotifier extends StateNotifier<String> {
  ViewNotifier() : super(ScanView.name);

  void setView(String routeName) async {
    state = routeName;
  }
}

final viewProvider = StateNotifierProvider<ViewNotifier, String>((ref) {
  return ViewNotifier();
});

class ContainerScreen extends ConsumerStatefulWidget {
  const ContainerScreen({super.key});

  @override
  ConsumerState<ContainerScreen> createState() => _ContainerScreenState();
}

class _ContainerScreenState extends ConsumerState<ContainerScreen> {
  bool isFail = true;
  final screens = {
    ScanView.name: ScanView(),
    SearchView.name: const SearchView(),
    PendingView.name: const PendingView(),
  };

  @override
  Widget build(BuildContext context) {
    final _selectedRouteName = ref.watch(viewProvider);
    final _pendingRecordsCount = ref.watch(internalDataProvider).count;

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
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: appBarTextColor),
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .controlAccess
                        .replaceAll('\n', ' '),
                    style:
                        const TextStyle(fontSize: 12, color: appBarTextColor),
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
                child: Image.asset(_pendingRecordsCount == 0
                    ? menuImgRoute
                    : warningMenuImgRoute),
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
                    height: SizeConfig.screenHeight * 0.12,
                    child: DrawerHeader(
                      decoration: const BoxDecoration(color: Colors.black),
                      padding: const EdgeInsets.only(left: 10),
                      margin: null,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: 8.0,
                              right: SizeConfig.screenWidth * 0.05),
                          child: Image.asset(
                            logoImageRoute,
                            height: SizeConfig.screenHeight * 0.12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '4 - ${AppLocalizations.of(context).controlAccess.replaceAll('\n', ' ')}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            Text(ref.read(authProvider).evento!.nome,
                                style: const TextStyle(color: Colors.grey))
                          ],
                        ),
                      ),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                              ref
                                  .read(authProvider)
                                  .equipamento!
                                  .numeroEquipamento,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 92,
                                  color: Color.fromRGBO(234, 234, 234, 1),
                                  fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),

                  //============================================================================================
                  //SCAN
                  DrawerTile(
                    onTap: () => _routeTileTapped(ScanView.name),
                    isSelected: ScanView.name == _selectedRouteName,
                    title:
                        Text(AppLocalizations.of(context).scan.toUpperCase()),
                  ),

                  //============================================================================================
                  //SEARCH
                  DrawerTile(
                    onTap: () => _routeTileTapped(SearchView.name),
                    isSelected: 'search' == _selectedRouteName,
                    title:
                        Text(AppLocalizations.of(context).search.toUpperCase()),
                  ),
                  //============================================================================================
                  //PENDING REQUESTS
                  DrawerTile(
                    onTap: () => _routeTileTapped(PendingView.name),
                    isSelected: 'pending' == _selectedRouteName,
                    title: Row(
                      children: [
                        Text(AppLocalizations.of(context)
                            .pendingRecords
                            .toUpperCase()),
                        SizedBox(
                          width: 4,
                        ),
                        if (_pendingRecordsCount > 0)
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color.fromRGBO(179, 39, 39, 1)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6.0, vertical: 2.0),
                              child: Text(
                                _pendingRecordsCount.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),

                  //============================================================================================
                  //EXIT
                  Consumer(
                    builder: (context, ref, child) {
                      return DrawerTile(
                        onTap: () async {
                          ref.read(authProvider.notifier).resetAuth();

                          //In Android¡'s case we exit the app
                          if (Platform.isAndroid) {
                            SystemChannels.platform
                                .invokeMethod('SystemNavigator.pop');
                            //iOS doesn't allow apps to exit themselves so we go to AuthScreen
                          } else {
                            final equips =
                                await DatabaseService.instance.readEquips();
                            final eventos =
                                await DatabaseService.instance.readEventos();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthScreen(
                                      equipamentos: equips ?? [],
                                      eventos: eventos ?? [])),
                            );
                          }
                        },
                        isSelected: false,
                        title: Text(
                            AppLocalizations.of(context).exit.toUpperCase()),
                      );
                    },
                  ),
                  /* DrawerTile(
                      onTap: () {}, isSelected: false, title: 'HISTÓRICO'), */
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 10.0, bottom: SizeConfig.screenHeight * 0.12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).contactsLabel,
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
        body: ViewContainer(
          child: screens[_selectedRouteName]!,
        ),
      ),
    );
  }

  void _routeTileTapped(String name) {
    Navigator.pop(context);
    ref.read(viewProvider.notifier).setView(name);
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
  final Widget title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: ListTile(
        title: title,
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
