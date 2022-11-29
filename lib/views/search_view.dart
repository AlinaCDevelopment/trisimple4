import '../helpers/size_helper.dart';
import '../widgets/themed_button.dart';
import '../widgets/themed_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/translation_service.dart';

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
          Text(MultiLang.texts.codeInsertLabel),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ThemedInput(
                onChanged: (value) => text = value,
                hintText: MultiLang.texts.codeInsertLabel),
          ),
          ThemedButton(
              onTap: () {
                //TODO LATER CHECK HOW APP 3 DOES THIS AND ASK WHAT TO DO WITH DEBUG SEARCH OPTION, WHAT INFORMATION TO SHOW?
              },
              text: MultiLang.texts.search)
        ],
      ),
    );
  }
}
