import 'package:app_4/constants/assets_routes.dart';
import 'package:app_4/models/database/equipamento.dart';
import 'package:app_4/models/database/evento.dart';
import 'package:app_4/screens/container_screen.dart';
import 'package:app_4/providers/auth_service.dart';
import 'package:app_4/services/database_service.dart';
import 'package:app_4/views/scan_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/colors.dart';
import '../widgets/utility/empty_scroll_behaviour.dart';

const _inputPadding = EdgeInsets.symmetric(horizontal: 30);
const _inputFontSize = 16.0;
const _bottomFontSize = 13.0;

final _inputRadius = BorderRadius.circular(50);

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: true, body: AuthView());
  }
}

class AuthView extends StatelessWidget {
  DropdownMenuItem<dynamic> _buildDropItem(String name, dynamic value) {
    return DropdownMenuItem(value: value, child: DropdownText(name));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: backGradient),
      child: CustomScrollView(
        scrollBehavior: EmptyScrollBehaviour(),
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            fillOverscroll: false,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                          right: 40, left: 40, top: 100, bottom: 20),
                      child: Image.asset(logoImageRoute)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          size: 30,
                        ),
                        Text(
                          AppLocalizations.of(context)!.reservedArea,
                          style: const TextStyle(
                              color: backColor,
                              fontSize: 21,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 90, right: 90, bottom: 45),
                    child: Text(
                      AppLocalizations.of(context)!.authorizedPeople,
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 48, vertical: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'APP 4',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 29),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.controlAccess,
                                  style: const TextStyle(
                                      color: accentColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                  textAlign: TextAlign.center,
                                ),
                                const Text(
                                  '(1.0.0)',
                                  style: TextStyle(
                                    fontSize: 19,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            FutureBuilder<Map<String, dynamic>>(
                                future: _getDatabaseData(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    List<Evento>? eventos =
                                        snapshot.data!['eventos'];
                                    List<Equipamento>? equipamentos =
                                        snapshot.data!['equipamentos'];
                                    List<DropdownMenuItem>? itemsEventos;
                                    List<DropdownMenuItem>? itemsEquipamentos;
                                    //_TypeError (type 'List<dynamic>' is not a subtype of type 'List<DropdownMenuItem<dynamic>>?')
                                    if (eventos != null) {
                                      itemsEventos = eventos
                                          .map((evento) => _buildDropItem(
                                              evento.nome, evento))
                                          .toList();
                                    }

                                    //TODO Remove
                                    itemsEventos = [Evento(id: 1, nome: 'nome')]
                                        .map((e) =>
                                            _buildDropItem(e.nome, e.toJson()))
                                        .toList();
                                    if (equipamentos != null) {
                                      itemsEquipamentos = equipamentos
                                          .map((equip) => _buildDropItem(
                                              equip.numeroEquipamento,
                                              equip.toJson()))
                                          .toList();
                                    }

                                    return AuthForm(
                                        eventos: itemsEventos ?? [],
                                        equipamentos: itemsEquipamentos ?? []);
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
          )
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _getDatabaseData() async {
    Map<String, dynamic> data = {};
    data['equipamentos'] = await DatabaseService.instance.readEquips();
    print('data: ${data['equipamentos']}');
    data['eventos'] = await DatabaseService.instance.readEventos();
    return data;
  }
}

class AuthForm extends StatelessWidget {
  AuthForm({
    Key? key,
    required this.eventos,
    required this.equipamentos,
  }) : super(key: key);

  final List<DropdownMenuItem> eventos;
  final List<DropdownMenuItem> equipamentos;

  final inputSpacement = const SizedBox(
    height: 8,
  );

  Equipamento? _equipSelected;
  Evento? _eventoSelected;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthDropdown(
            eventos,
            onChanged: (String value) {
              _eventoSelected = Evento.fromJson(value);
            },
            hintText: AppLocalizations.of(context)!.eventSelectHint,
          ),
          inputSpacement,
          AuthDropdown(
            equipamentos,
            onChanged: (value) {
              _equipSelected = Equipamento.fromJson(value);
            },
            hintText: AppLocalizations.of(context)!.equipSelectHint,
          ),
          inputSpacement,
          const PasswordInput(),
          inputSpacement,
          _buildSubmitButton(),
          const SizedBox(
            height: 50,
          ),
          Column(children: [
            Text(
              AppLocalizations.of(context)!.emailLabel,
              style: const TextStyle(fontSize: _bottomFontSize),
            ),
            const Text(
              'info@trisimple.pt',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: _bottomFontSize),
            ),
          ]),
        ],
      ),
    );
  }

  _buildSubmitButton() {
    return Consumer(
      builder: (context, ref, container) {
        return GestureDetector(
          onTap: () async {
            if (_equipSelected != null && _eventoSelected != null) {
              bool valid = await ref.read(authProvider.notifier).authenticate(
                  equipamento: _equipSelected!,
                  evento: _eventoSelected!,
                  password: 'password');
              if (valid) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ContainerScreen(
                            title: _eventoSelected!.nome,
                          )),
                );
              } else {
                //TODO Wrong password WARNING
              }
            } else {
              //TODO Fill in EVERYTHING WARNING
            }
          },
          child: Container(
              height: 48,
              decoration: BoxDecoration(
                  borderRadius: _inputRadius,
                  gradient: const LinearGradient(
                      colors: gradientColors,
                      end: Alignment.bottomLeft,
                      begin: Alignment.topRight)),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.signIn,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              )),
        );
      },
    );
  }
}

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    Key? key,
  }) : super(key: key);

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  var _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: !_isPasswordVisible,
      style: const TextStyle(color: hintColor),
      decoration: InputDecoration(
        focusColor: accentColor,
        hintText: AppLocalizations.of(context)!.passwordHint,
        contentPadding: _inputPadding,
        border: InputBorder.none,
        filled: true,
        hintStyle: const TextStyle(fontSize: _inputFontSize),
        fillColor: canvasColor,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: _inputRadius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: _inputRadius,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }
}

class AuthDropdown extends StatefulWidget {
  const AuthDropdown(
    this.dropdownItems, {
    this.hintText = '',
    this.onChanged,
    Key? key,
  }) : super(key: key);
  final List<DropdownMenuItem<dynamic>> dropdownItems;
  final String hintText;
  final Function(String value)? onChanged;

  @override
  State<AuthDropdown> createState() => _AuthDropdownState();
}

class _AuthDropdownState extends State<AuthDropdown> {
  dynamic selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(),
            borderRadius: _inputRadius),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: selectedValue,
              isExpanded: true,
              hint: DropdownText(widget.hintText),
              items: widget.dropdownItems,
              onChanged: ((value) {
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
                selectedValue = value;
                setState(() {});
              }),
              icon: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_drop_down),
              ),
              iconEnabledColor: Theme.of(context).iconTheme.color,
              iconDisabledColor: Theme.of(context).iconTheme.color,
              style: const TextStyle(color: hintColor),
            ),
          ),
        ));
  }
}

class DropdownText extends StatelessWidget {
  const DropdownText(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Text(
        text,
        style: const TextStyle(color: hintColor, fontSize: _inputFontSize),
      ),
    );
  }
}
