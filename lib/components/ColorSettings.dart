import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:mycontacts_free/contactDb.dart';
import 'package:mycontacts_free/main.dart';
import 'package:mycontacts_free/state/appSettings.dart';
import 'package:mycontacts_free/utils/admobUtils.dart';
import 'package:mycontacts_free/utils/colors.dart';
import 'package:mycontacts_free/utils/utils.dart';
import 'package:mycontacts_free/utils/widgetUitls.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vcard/vcard.dart';
import 'package:pdf/widgets.dart' as p;

class ColorSettings extends StatefulWidget {
  @override
  _ColorSettingsState createState() => _ColorSettingsState();
}

class _ColorSettingsState extends State<ColorSettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.settingsTile(
        icon: Icons.color_lens,
        title: translatedText("settings_theme", context),
        onTap: () async {
          showDialog(context: context, builder: (_) => ColorPickerDialog());
        });
  }
}

class ColorPickerDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetUtils.dialog(
      title: translatedText("settings_export_contacts", context),
      context: context,
      height: MediaQuery.of(context).size.height * .6,
      child: ColorPicker(),
    );
  }
}

class ColorPicker extends StatefulWidget {
  final List<String> filepaths = [];
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppSettings appSettings = AppSettings.of(context);

    return Container(
        child: Expanded(
      child: MaterialColorPicker(
        allowShades: false,
        onMainColorChange: (Color color) {
          print("COLORS");
          print(color.value);
          print(color);
          appSettings.callback(color);
          prefs.setInt('color', color.value);
        },
        selectedColor: appSettings.color,
      ),
    ));
  }
}
