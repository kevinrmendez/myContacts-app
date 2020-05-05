import 'package:flutter/material.dart';
import 'package:mycontacts_free/main.dart';
import 'package:mycontacts_free/state/appSettings.dart';
import 'package:mycontacts_free/utils/myThemes.dart';
import 'package:mycontacts_free/utils/utils.dart';

class ExpandableThemeSettings extends StatefulWidget {
  final BuildContext context;
  ExpandableThemeSettings(this.context);
  @override
  ExpandableThemeSettingsState createState() => ExpandableThemeSettingsState();
}

class ExpandableThemeSettingsState extends State<ExpandableThemeSettings> {
  // This widget is the root of your application.
  bool changeTheme;
  // ThemeData _theme;
  int thmekeyIndex;
  MyThemeKeys themekey;
  List<Item> items;

  @override
  void initState() {
    print(prefs.getInt('themeKey'));
    thmekeyIndex = (prefs.getInt('themeKey') ?? 0);
    themekey = MyThemeKeys.values[thmekeyIndex];
    items = [
      Item(headerValue: translatedText("settings_theme", widget.context))
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppSettings appState = AppSettings.of(context);
    void _changeTheme(value) async {
      setState(() {
        themekey = value;
      });
      appState.callback(themeKey: themekey);

      // print(appState.themeKey);
      // print(themekey.toString());
      switch (value) {
        case MyThemeKeys.BLUE:
          await prefs.setInt('themeKey', 0);
          break;
        case MyThemeKeys.BLACK:
          await prefs.setInt('themeKey', 1);
          break;
        case MyThemeKeys.GREEN:
          await prefs.setInt('themeKey', 2);
          break;
        case MyThemeKeys.NAVY:
          await prefs.setInt('themeKey', 3);
          break;
        case MyThemeKeys.PINK:
          await prefs.setInt('themeKey', 4);
          break;
        case MyThemeKeys.PURPLE:
          await prefs.setInt('themeKey', 5);
          break;
        case MyThemeKeys.RED:
          await prefs.setInt('themeKey', 6);
          break;
        case MyThemeKeys.TEAL:
          await prefs.setInt('themeKey', 7);
          break;
        case MyThemeKeys.YELLOW:
          await prefs.setInt('themeKey', 8);
          break;
        case MyThemeKeys.DARK:
          await prefs.setInt('themeKey', 9);
          break;

        default:
      }
    }

    return ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            items[index].isExpanded = !isExpanded;
          });
        },
        children: items.map<ExpansionPanel>((Item item) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(item.headerValue),
              );
            },
            body: Card(
              child: Column(children: [
                ListTile(
                  title: Text(translatedText("color_blue", context)),
                  leading: Radio(
                    value: MyThemeKeys.BLUE,
                    groupValue: themekey,
                    onChanged: (value) {
                      _changeTheme(value);
                    },
                  ),
                ),
                ListTile(
                  title: Text(translatedText("color_black", context)),
                  leading: Radio(
                    value: MyThemeKeys.BLACK,
                    groupValue: themekey,
                    onChanged: (value) {
                      _changeTheme(value);
                    },
                  ),
                ),
                ListTile(
                  title: Text(translatedText("color_green", context)),
                  leading: Radio(
                    value: MyThemeKeys.GREEN,
                    groupValue: themekey,
                    onChanged: (value) {
                      _changeTheme(value);
                    },
                  ),
                ),
                ListTile(
                  title: Text(translatedText("color_navy", context)),
                  leading: Radio(
                    value: MyThemeKeys.NAVY,
                    groupValue: themekey,
                    onChanged: (value) {
                      _changeTheme(value);
                    },
                  ),
                ),
                ListTile(
                  title: Text(translatedText("color_orange", context)),
                  leading: Radio(
                    value: MyThemeKeys.ORANGE,
                    groupValue: themekey,
                    onChanged: (value) {
                      _changeTheme(value);
                    },
                  ),
                ),
                ListTile(
                  title: Text(translatedText("color_pink", context)),
                  leading: Radio(
                    value: MyThemeKeys.PINK,
                    groupValue: themekey,
                    onChanged: (value) {
                      _changeTheme(value);
                    },
                  ),
                ),
                ListTile(
                  title: Text(translatedText("color_purple", context)),
                  leading: Radio(
                    value: MyThemeKeys.PURPLE,
                    groupValue: themekey,
                    onChanged: (value) {
                      _changeTheme(value);
                    },
                  ),
                ),
                ListTile(
                  title: Text(translatedText("color_red", context)),
                  leading: Radio(
                    value: MyThemeKeys.RED,
                    groupValue: themekey,
                    onChanged: (value) {
                      _changeTheme(value);
                    },
                  ),
                ),
                ListTile(
                  title: Text(translatedText("color_teal", context)),
                  leading: Radio(
                    value: MyThemeKeys.TEAL,
                    groupValue: themekey,
                    onChanged: (value) {
                      _changeTheme(value);
                    },
                  ),
                ),
                ListTile(
                  title: Text(translatedText("color_yellow", context)),
                  leading: Radio(
                    value: MyThemeKeys.YELLOW,
                    groupValue: themekey,
                    onChanged: (value) {
                      _changeTheme(value);
                    },
                  ),
                ),
                ListTile(
                  title: Text(translatedText("color_dark", context)),
                  leading: Radio(
                    value: MyThemeKeys.DARK,
                    groupValue: themekey,
                    onChanged: (value) {
                      _changeTheme(value);
                    },
                  ),
                ),
              ]),
            ),
            canTapOnHeader: true,
            isExpanded: item.isExpanded,
          );
        }).toList());
  }
}

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  List<Widget> expandedValue;
  String headerValue;
  bool isExpanded;
}
