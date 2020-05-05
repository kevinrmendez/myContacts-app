import 'package:flutter/material.dart';
import 'package:mycontacts_free/utils/myThemes.dart';

class AppSettings extends InheritedWidget {
  final Function callback;
  Color color;

  AppSettings({this.callback, Widget child, this.color}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AppSettings of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(AppSettings);
}
