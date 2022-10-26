import 'package:app_4/constants/assets_routes.dart';
import 'package:app_4/screens/scan_screen.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../widgets/utility/empty_scroll_behaviour.dart';

const _inputPadding = EdgeInsets.symmetric(horizontal: 30);
const _inputFontSize = 16.0;
const _bottomFontSize = 13.0;

final _inputRadius = BorderRadius.circular(50);

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final events = List<DropdownMenuItem<dynamic>>.from([
      buildDropItem('evento 1', '1'),
      buildDropItem('evento 2', '2'),
      buildDropItem('evento 3', '3'),
      buildDropItem('evento 4', '4')
    ]);
    final equipments = List<DropdownMenuItem<dynamic>>.from([
      buildDropItem('equipamento 1', '1'),
      buildDropItem('equipamento 2', '2'),
      buildDropItem('equipamento 3', '3'),
      buildDropItem('equipamento 4', '4')
    ]);
    const inputSpacement = SizedBox(
      height: 8,
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
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
                        children: const [
                          Icon(
                            Icons.lock_outline,
                            size: 30,
                          ),
                          Text(
                            'Área Reservada',
                            style: TextStyle(
                                color: backColor,
                                fontSize: 21,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 90, right: 90, bottom: 45),
                      child: Text(
                        'Só é permitida a entrada a pessoas autorizadas pela Trisimple',
                        style: TextStyle(
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
                                children: const [
                                  Text(
                                    '- APP 4 -\nControlo de Acessos',
                                    style: TextStyle(
                                        color: accentColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 29),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
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
                              Form(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    AuthDropdown(events,
                                        hintText: 'Seleciona o evento'),
                                    inputSpacement,
                                    AuthDropdown(equipments,
                                        hintText: 'Seleciona o equipamento'),
                                    inputSpacement,
                                    const PasswordInput(),
                                    inputSpacement,
                                    SubmitButton(),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    Column(children: const [
                                      Text(
                                        'Para mais informações envie email para:',
                                        style: TextStyle(
                                            fontSize: _bottomFontSize),
                                      ),
                                      Text(
                                        'info@trisimple.pt',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: _bottomFontSize),
                                      ),
                                    ]),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ]),
            )
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<dynamic> buildDropItem(String name, String value) {
    return DropdownMenuItem(value: value, child: DropdownText(name));
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ScanScreen.routeName);
      },
      child: Container(
          height: 48,
          decoration: BoxDecoration(
              borderRadius: _inputRadius,
              gradient: const LinearGradient(
                  colors: gradientColors,
                  end: Alignment.bottomLeft,
                  begin: Alignment.topRight)),
          child: const Center(
            child: Text(
              'Inscreve-te',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          )),
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
      style: TextStyle(color: hintColor),
      decoration: InputDecoration(
        focusColor: accentColor,
        hintText: 'Insere a palavra-passe',
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
    Key? key,
  }) : super(key: key);
  final List<DropdownMenuItem<dynamic>> dropdownItems;
  final String hintText;

  @override
  State<AuthDropdown> createState() => _AuthDropdownState();
}

class _AuthDropdownState extends State<AuthDropdown> {
  String? selectedValue;

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
