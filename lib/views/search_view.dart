import 'package:app_4/services/tag_validation_methods.dart';

import '../helpers/size_helper.dart';
import '../services/l10n/app_localizations.dart';
import '../widgets/themed_button.dart';
import '../widgets/themed_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//TODO GO BACK TO APPLOCALIZATIONS.OF CONTEXT
//TODO CREATE TABLE PULSEIRA WITH PULSEIRA ID AND PHYSIC ID
class SearchView extends ConsumerWidget {
  SearchView({super.key});
  static const name = 'search';
  String text = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 30.0, vertical: SizeConfig.screenHeight * 0.06),
      child: Column(
        children: [
          Text(AppLocalizations.of(context).codeInsertLabel),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ThemedInput(
                onChanged: (value) => text = value,
                hintText: AppLocalizations.of(context).codeInsertLabel),
          ),
          ThemedButton(
              onTap: () {
                //TODO GET TAG AND RUN THE FOLLOWING COMMAND
                //   validateTag(context, tag: tag, ref: ref);
                //TODO LATER CHECK HOW APP 3 DOES THIS AND ASK WHAT TO DO WITH DEBUG SEARCH OPTION, WHAT INFORMATION TO SHOW?
              },
              text: AppLocalizations.of(context).search)
        ],
      ),
    );
  }
}
