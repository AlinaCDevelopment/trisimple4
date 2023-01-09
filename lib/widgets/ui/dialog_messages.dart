import 'dart:ui';
import 'package:app_4/models/database/evento.dart';
import '../../constants/assets_routes.dart';
import '../../services/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../helpers/size_helper.dart';
import '../../models/event_tag.dart';

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

class DialogMessage extends StatelessWidget {
  const DialogMessage(
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

Future<T?> showMessageDialog<T>(BuildContext context, Widget message) async {
  if (Navigator.canPop(context)) Navigator.pop(context);
  return await showDialog<T>(
    context: context,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: message);
    },
  );
}
