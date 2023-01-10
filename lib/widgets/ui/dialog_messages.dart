import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:app_4/models/database/evento.dart';
import 'package:app_4/screens/auth_screen.dart';
import '../../constants/assets_routes.dart';
import '../../services/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../helpers/size_helper.dart';
import '../../models/event_tag.dart';

import '../themed_button.dart';
import '../themed_input.dart';

class ScanErrorMessage extends StatelessWidget {
  const ScanErrorMessage({this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return ScanDialogMessage(
        title: AppLocalizations.of(context).error,
        content: message != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  message!,
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              )
            : null,
        assetPngImgName: errorImgRoute);
  }
}

class ScanValidationMessage extends StatelessWidget {
  const ScanValidationMessage(
      {Key? key,
      required this.availability,
      required this.eventTag,
      required this.message})
      : super(key: key);

  final Bilhete eventTag;
  final bool availability;
  final String message;

  @override
  Widget build(BuildContext context) {
    final validationText = availability
        ? AppLocalizations.of(context).valid
        : AppLocalizations.of(context).invalid;
    String durationText;

    return ScanDialogMessage(
      assetPngImgName: availability ? validImgRoute : invalidImgRoute,
      title: validationText,
      content: Column(children: [
        FittedBox(
          child: Column(
            children: [
              Text(
                textAlign: TextAlign.center,
                eventTag.title,
                style: const TextStyle(color: Colors.grey, fontSize: 23),
              ),
              Text(
                textAlign: TextAlign.center,
                message,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
        SizedBox(
          height: SizeConfig.screenHeight * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: QrImage(
                    //TODO ASK IF YOU'RE TO STORE THE UNIQUECODE IN THE TAG
                    data: "1234567890",
                    version: QrVersions.auto,
                    //size: 200.0,
                  ),
                ),
                Text(
                  AppLocalizations.of(context).ticket,
                  style: const TextStyle(fontSize: 17, color: Colors.black54),
                )
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: QrImage(
                    data: "1234567890",
                    version: QrVersions.auto,
                    //size: 200.0,
                  ),
                ),
                Text(
                  AppLocalizations.of(context).bracelet,
                  style: const TextStyle(fontSize: 17, color: Colors.black54),
                )
              ],
            ),
          ],
        )
      ]),
    );
  }
}

class ScanDialogMessage extends StatefulWidget {
  const ScanDialogMessage(
      {super.key,
      required this.title,
      this.content,
      required this.assetPngImgName});
  final String title;
  final Widget? content;
  final String assetPngImgName;

  @override
  State<ScanDialogMessage> createState() => _ScanDialogMessageState();
}

class _ScanDialogMessageState extends State<ScanDialogMessage> {
  double _height = 0;
  double _width = 0;
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          _height = SizeConfig.screenHeight * 0.66;
          _width = SizeConfig.screenWidth * 0.85;
          _opacity = 1;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AnimatedOpacity(
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 250),
      opacity: _opacity,
      child: AnimatedSize(
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 250),
        child: Container(
            height: _height,
            width: _width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                      ),
                    ),
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            right: SizeConfig.screenWidth * 0.2,
                            left: SizeConfig.screenWidth * 0.2,
                            top: 50),
                        child: Image.asset(widget.assetPngImgName),
                      ),
                      Column(
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 40),
                          ),
                          widget.content ?? Container()
                        ],
                      ),
                    ]),
              ],
            )),
      ),
    ));
  }
}

class MessageDialog extends StatelessWidget {
  const MessageDialog(
      {super.key,
      required this.title,
      required this.content,
      this.hideExit = false});
  final String title;
  final String content;
  final bool hideExit;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            height: SizeConfig.screenHeight * 0.25,
            width: SizeConfig.screenWidth * 0.85,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (!hideExit)
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(
                          Icons.close,
                          color: Colors.grey,
                        ),
                      ),
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromARGB(255, 29, 29, 29)
                                .withOpacity(0.7),
                            fontSize: 30),
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.02,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: FittedBox(
                          child: Text(
                            content,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromARGB(115, 14, 14, 14),
                                fontSize: 20),
                          ),
                        ),
                      )
                    ]),
              ],
            )));
  }
}

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    Key? key,
    required this.onChanged,
  }) : super(key: key);
  final Function(String) onChanged;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  var _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return ThemedInput(
      onChanged: widget.onChanged,
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

class InputDialog extends StatelessWidget {
  InputDialog(
      {super.key,
      required this.title,
      required this.content,
      this.obscureText = false,
      this.hideExit = false});
  String _password = '';
  final String title;
  final bool obscureText;
  final String content;
  final bool hideExit;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            height: SizeConfig.screenHeight * 0.4,
            width: SizeConfig.screenWidth * 0.85,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
            child: Material(
              color: Colors.transparent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (!hideExit)
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Icon(
                            Icons.close,
                            color: Colors.grey,
                          ),
                        ),
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context).logoutTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: const Color.fromARGB(255, 29, 29, 29)
                                  .withOpacity(0.7),
                              fontSize: 30),
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            AppLocalizations.of(context).logoutContent,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Color.fromARGB(115, 14, 14, 14),
                                fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.screenWidth * 0.12,
                              vertical: SizeConfig.screenWidth * 0.04),
                          child: Material(
                            elevation: 4.0,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(50),
                            child: TextFormField(
                              onChanged: (value) {
                                Colors.amber;
                              },
                              obscureText: obscureText,
                              style: const TextStyle(
                                  color: Color.fromARGB(115, 14, 14, 14),
                                  overflow: TextOverflow.clip),
                              decoration: InputDecoration(
                                label: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    AppLocalizations.of(context).passwordHint,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(115, 14, 14, 14),
                                    ),
                                  ),
                                ),
                                alignLabelWithHint: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                focusColor: Colors.amber,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                border: InputBorder.none,
                                filled: true,
                                labelStyle: const TextStyle(
                                    fontSize: 15, overflow: TextOverflow.clip),
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 0.1,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 0.1,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                suffixIcon: PasswordInput(
                                  onChanged: (value) {
                                    _password = value;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.screenWidth * 0.12),
                          child: ThemedButton(
                              onTap: () =>
                                  Navigator.pop(context, _controller.text),
                              text: AppLocalizations.of(context).logoutConfirm),
                        ),
                      ]),
                ],
              ),
            )));
  }
}

Future<T?> showMessageDialog<T>(BuildContext context, Widget message) async {
  try {
    if (ModalRoute.of(context)?.isCurrent != true &&
        Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    return showDialog<T>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: message);
      },
    );
  } catch (e) {
    return null;
  }
}
