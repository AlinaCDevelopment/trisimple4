import 'package:app_4/widgets/themed_input.dart';
import 'package:flutter/material.dart';

import '../services/l10n/app_localizations.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    Key? key,
    this.onChanged,
    this.controller,
  }) : super(key: key);
  final Function(String)? onChanged;
  final TextEditingController? controller;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  var _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return ThemedInput(
      controller: widget.controller,
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
