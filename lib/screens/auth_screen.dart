import 'package:app_4/widgets/ui/dialog_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/assets_routes.dart';
import '../constants/colors.dart';
import '../helpers/size_helper.dart';
import '../models/database/equipamento.dart';
import '../models/database/evento.dart';
import '../providers/auth_provider.dart';
import '../widgets/themed_button.dart';
import '../widgets/themed_input.dart';
import '../widgets/utility/empty_scroll_behaviour.dart';
import 'container_screen.dart';

const _inputPadding = EdgeInsets.symmetric(horizontal: 30);
const _inputFontSize = 15.0;
const _bottomFontSize = 13.0;

final _inputRadius = BorderRadius.circular(50);
String _password = '';
int? _equipSelected;
int? _eventoSelected;

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key, required this.equipamentos, required this.eventos});
  final List<Equipamento> equipamentos;
  final List<Evento> eventos;

  List<DropdownMenuItem>? itemsEventos;
  List<DropdownMenuItem>? itemsEquipamentos;
  final inputSpacement = SizedBox(
    height: SizeConfig.screenHeight * 0.02,
  );

  DropdownMenuItem<dynamic> _buildDropItem(String name, dynamic value) {
    return DropdownMenuItem(value: value, child: DropdownText(name));
  }

  _buildSubmitButton() {
    return Consumer(
      builder: (context, ref, container) {
        return ThemedButton(
            onTap: () async {
              if (_equipSelected != null &&
                  _eventoSelected != null &&
                  _password.isNotEmpty) {
                bool valid = await ref.read(authProvider.notifier).authenticate(
                    equipamento: equipamentos
                        .singleWhere((element) => element.id == _equipSelected),
                    evento: eventos.singleWhere(
                        (element) => element.id == _eventoSelected),
                    password: _password);
                if (valid) {
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContainerScreen()),
                  );
                } else {
                  await showMessageDialog(
                      context,
                      DialogMessage(
                          title: 'Upsss!',
                          content: AppLocalizations.of(context).wrongPassword));
                }
              } else {
                await showMessageDialog(
                    context,
                    DialogMessage(
                        title: 'Upsss!',
                        content: AppLocalizations.of(context).fillAllFields));
              }
            },
            text: AppLocalizations.of(context).signIn);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SizedBox(
          height: SizeConfig.screenHeight + SizeConfig.viewInsets.bottom,
          width: SizeConfig.screenWidth,
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImgRoute), fit: BoxFit.fill)),
            child: SizedBox(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              child: CustomScrollView(
                scrollBehavior: EmptyScrollBehaviour(),
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    fillOverscroll: false,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.screenHeight * 0.11,
                          bottom: SizeConfig.screenHeight * 0.07),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.screenWidth * 0.07),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.screenWidth * 0.07),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Image.asset(logoImageRoute),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: SizeConfig.screenHeight * 0.04),
                                  child: Column(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)
                                            .reservedArea,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .controlAccess,
                                          style: const TextStyle(
                                              color: secondColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 50),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Builder(builder: (context) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: SizeConfig.screenHeight * 0.02),
                                    child: Form(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .authorizedPeople,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          AuthDropdown(
                                            eventos
                                                .map((evento) => _buildDropItem(
                                                    evento.nome, evento.id))
                                                .toList(),
                                            onChanged: (value) {
                                              if (value != null)
                                                _eventoSelected = value;
                                            },
                                            hintText:
                                                AppLocalizations.of(context)
                                                    .eventSelectHint,
                                          ),
                                          inputSpacement,
                                          AuthDropdown(
                                            equipamentos
                                                .map((equip) => _buildDropItem(
                                                    '${equip.tipoEquipamento} #${equip.numeroEquipamento}',
                                                    equip.id))
                                                .toList(),
                                            onChanged: (value) {
                                              if (value != null)
                                                _equipSelected = value;
                                            },
                                            hintText:
                                                AppLocalizations.of(context)
                                                    .equipSelectHint,
                                          ),
                                          inputSpacement,
                                          const PasswordInput(),
                                          inputSpacement,
                                          _buildSubmitButton(),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.screenWidth * 0.07),
                                  child: Column(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context).emailLabel,
                                        style: const TextStyle(
                                          fontSize: 11,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const Text(
                                        'info@trisimple.pt',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: SizeConfig.screenHeight * 0.01,
                                      ),
                                      Text(
                                        '${AppLocalizations.of(context).version}: 1.0.0',
                                        style: TextStyle(
                                            fontSize: 11, color: thirdColor),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
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
  var _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return ThemedInput(
      onChanged: (value) {
        _password = value;
      },
      obscureText: _isPasswordHidden,
      hintText: AppLocalizations.of(context).passwordHint,
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordHidden
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: Theme.of(context).iconTheme.color,
        ),
        onPressed: () {
          setState(() {
            _isPasswordHidden = !_isPasswordHidden;
          });
        },
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
  final Function(dynamic value)? onChanged;

  @override
  State<AuthDropdown> createState() => _AuthDropdownState();
}

class _AuthDropdownState extends State<AuthDropdown> {
  dynamic selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:
            BoxDecoration(color: Colors.white, borderRadius: _inputRadius),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              itemHeight: 50,
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
