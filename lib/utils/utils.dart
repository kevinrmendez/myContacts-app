import 'package:flutter/material.dart';
import 'package:mycontacts_free/app_localizations.dart';

String translatedText(text, BuildContext context) {
  return AppLocalizations.of(context).translate(text);
}
