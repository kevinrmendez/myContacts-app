import 'package:flutter/material.dart';

enum MyThemeKeys {
  BLUE,
  BLACK,
  GREEN,
  NAVY,
  ORANGE,
  PINK,
  PURPLE,
  RED,
  TEAL,
  YELLOW,
  DARK
}

class MyThemes {
  static final ThemeData blueTheme = ThemeData(
    primaryColor: Colors.blue,
    primaryIconTheme: IconThemeData(color: Colors.white),
    accentColor: Colors.blue[200],
    brightness: Brightness.light,
  );

  static final ThemeData redTheme = ThemeData(
    primaryColor: Colors.red,
    accentColor: Colors.red[200],
    brightness: Brightness.light,
  );

  static final ThemeData yellowTheme = ThemeData(
    primaryColor: Colors.yellow,
    accentColor: Colors.yellow[200],
    brightness: Brightness.light,
  );
  static final ThemeData navyTheme = ThemeData(
    primaryColor: Color.fromRGBO(0, 0, 139, 1),
    accentColor: Color(0xFFFFBD59),
    brightness: Brightness.light,
  );
  static final ThemeData blackTheme = ThemeData(
    primaryColor: Color.fromRGBO(0, 0, 0, 1),
    accentColor: Color.fromRGBO(0, 0, 0, 1),
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.cyan,
    accentColor: Colors.cyan,
    brightness: Brightness.dark,
  );

  static final ThemeData greenTheme = ThemeData(
    primaryColor: Colors.green,
    accentColor: Colors.green[200],
    brightness: Brightness.light,
  );
  static final ThemeData pinkTheme = ThemeData(
    primaryColor: Colors.pink,
    accentColor: Colors.pink[200],
    brightness: Brightness.light,
  );
  static final ThemeData orangeTheme = ThemeData(
    primaryColor: Colors.orange,
    accentColor: Colors.orange[200],
    brightness: Brightness.light,
  );
  static final ThemeData purpleTheme = ThemeData(
    primaryColor: Colors.purple,
    accentColor: Colors.purple[200],
    brightness: Brightness.light,
  );
  static final ThemeData tealTheme = ThemeData(
    primaryColor: Colors.teal,
    accentColor: Colors.teal[200],
    brightness: Brightness.light,
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.BLUE:
        return blueTheme;
      case MyThemeKeys.RED:
        return redTheme;
      case MyThemeKeys.GREEN:
        return greenTheme;
      case MyThemeKeys.YELLOW:
        return yellowTheme;
      case MyThemeKeys.PINK:
        return pinkTheme;
      case MyThemeKeys.ORANGE:
        return orangeTheme;
      case MyThemeKeys.PURPLE:
        return purpleTheme;
      case MyThemeKeys.NAVY:
        return navyTheme;
      case MyThemeKeys.BLACK:
        return blackTheme;
      case MyThemeKeys.TEAL:
        return tealTheme;
      case MyThemeKeys.DARK:
        return darkTheme;
      default:
        return blueTheme;
    }
  }
}
