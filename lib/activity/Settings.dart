import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mycontacts_free/ContactDb.dart';
import 'package:mycontacts_free/activity/blockedContactsActivity.dart';
import 'package:mycontacts_free/activity/contactActivity.dart';
import 'package:mycontacts_free/activity/statisticsActivity.dart';
import 'package:mycontacts_free/components/ColorSettings.dart';
import 'package:mycontacts_free/components/expandableExportSettings.dart';
import 'package:mycontacts_free/components/expandableThemeSettings.dart';
import 'package:mycontacts_free/components/exportSettings.dart';
import 'package:mycontacts_free/contact.dart';
import 'package:mycontacts_free/main.dart';
import 'package:mycontacts_free/state/appSettings.dart';
import 'package:mycontacts_free/state/appState.dart';
import 'package:mycontacts_free/utils/colors.dart';
import 'package:mycontacts_free/utils/utils.dart';
import 'package:mycontacts_free/utils/widgetUitls.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

import 'package:contacts_service/contacts_service.dart' as a;
import 'package:mycontacts_free/ContactDb.dart';

import 'package:url_launcher/url_launcher.dart';

import 'aboutActivity .dart';

final ContactDb _db = ContactDb();
final snackBar = (text) => SnackBar(content: Text(text));

class Settings extends StatefulWidget {
  final PermissionHandler _permissionHandler = PermissionHandler();

  Future<bool> _requestContactPermission() async {
    var result =
        await _permissionHandler.requestPermissions([PermissionGroup.contacts]);

    if (result[PermissionGroup.contacts] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  @override
  SettingsState createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  bool importedContacts;
  bool importedContactsProgress;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ContactDb db = ContactDb();
  PermissionStatus _permissionStatus;

  // ThemeData _theme;
  // MyThemeKeys themekey;
  // bool isExpanded;

  // Future<int> themekeyprefs;

  // Future<Null> getSharePreferences() async {
  //   prefs = await SharedPreferences.getInstance();
  // }

  @override
  void initState() {
    importedContacts = (prefs.getBool('importedContacts') ?? false);
    importedContactsProgress = false;
    // isExpanded = false;
    super.initState();
    // Prefs.init();
    // getSharePreferences();
    // themekeyprefs = Prefs.getIntF('themekey') ?? 0;
    // themekey = MyThemeKeys.values[themekeyprefs];
  }

  @override
  Widget build(BuildContext context) {
    //WARNING MESSAGE BEFORE DELETING CONTACTS
    void _warningMessage(String message) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                message,
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text(
                      'close',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      // Navigator.of(context).pop();
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    }),
                FlatButton(
                    child: Text(
                      'ok',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () async {
                      await _db.deleteAllContacts();

                      Navigator.pop(context);
                    })
              ],
            );
          });
    }

    _deleteContacts() async {
      _warningMessage('Are you sure you want to delete all your contacts');
    }

    _importContactsFromService() async {
      Iterable<a.Contact> contacts = await a.ContactsService.getContacts();
      contacts.map((value) {});

      return contacts;
    }

    _importContacts() {
      print('CONTACTS');
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => WidgetUtils.dialog(
              title: translatedText("dialog_title_importing", context),
              context: context,
              height: MediaQuery.of(context).size.height * .35,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * .8,
                    child: Text(
                      translatedText(
                        "dialog_description_importing",
                        context,
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,

                        // fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator()),
                      ],
                    ),
                  ),
                ],
              )));

      _importContactsFromService().then((contacts) {
        setState(() {
          importedContactsProgress = true;
        });

        List contactList = contacts.toList();
        contactList.forEach((contact) {
          List phones = contact.phones.toList();
          List emails = contact.emails.toList();
          String email = emails.length > 0 ? emails[0].value : "";
          String phone = phones.length > 0 ? phones[0].value : "";
          String name = contact.displayName == null || contact.displayName == ""
              ? translatedText("text_empty_name", context)
              : contact.displayName;
          String category = translatedText("group_default", context);

          if (contact != null) {
            Contact newContact = Contact(
                name: name, email: email, phone: phone, category: category);

            db.insertContact(newContact);

            print(email);
            print(contact.displayName);
            print(phone);
            print(category);
            contactService.add(newContact);
          }
        });
      }).then((onValue) {
        print(onValue);
        setState(() {
          importedContacts = true;
          prefs.setBool('importedContacts', importedContacts);
          importedContactsProgress = false;
        });
        _scaffoldKey.currentState.showSnackBar(
            snackBar(translatedText("snackbar_contact_import", context)));
        Navigator.pop(context);
      }).catchError((e) {
        print('ERROR');
        print(e);
      });
    }

    Future<PermissionStatus> _checkPermission(
        PermissionGroup permissionGroup) async {
      PermissionStatus permission =
          await PermissionHandler().checkPermissionStatus(permissionGroup);
      return permission;
    }

    Future<Map<PermissionGroup, PermissionStatus>> _requestPermission(
        PermissionGroup permissionGroup) async {
      // await PermissionHandler()
      //     .shouldShowRequestPermissionRationale(PermissionGroup.contacts);
      // await PermissionHandler().openAppSettings();
      _permissionStatus = await _checkPermission(permissionGroup);
      if (_permissionStatus != PermissionStatus.granted) {
        return await PermissionHandler().requestPermissions([permissionGroup]);
      }
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home()),
          (Route<dynamic> route) => false,
        );
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(translatedText("app_title_settings", context)),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false,
                );
              }),
        ),
        body: Builder(
          builder: (context) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: ListView(
                  children: <Widget>[
                    WidgetUtils.settingsTile(
                        icon: Icons.info,
                        title: translatedText("settings_about", context),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutActivity()),
                          );
                        }),
                    WidgetUtils.settingsTile(
                      icon: Icons.remove_circle,
                      title: translatedText("settings_adfree", context),
                      onTap: () async {
                        String url =
                            "https://play.google.com/store/apps/details?id=com.mycontacts";
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                    WidgetUtils.settingsTile(
                        icon: Icons.assessment,
                        title: translatedText("settings_statistics", context),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StatisticsActivity()),
                          );
                        }),
                    WidgetUtils.settingsTile(
                        icon: Icons.feedback,
                        title: translatedText("settings_rate_app", context),
                        onTap: () async {
                          String url =
                              "https://play.google.com/store/apps/details?id=com.kevinrmendez.contact_app";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }),
                    importedContacts == false
                        ? WidgetUtils.settingsTile(
                            icon: Icons.import_contacts,
                            title: translatedText(
                                "settings_import_contacts", context),
                            onTap: () async {
                              var permissionStatus = await widget
                                  ._permissionHandler
                                  .checkPermissionStatus(
                                      PermissionGroup.contacts);

                              if (permissionStatus ==
                                  PermissionStatus.granted) {
                                _importContacts();
                              } else {
                                widget._requestContactPermission();
                              }
                            })
                        : const SizedBox(),
                    contactService.current.length > 0
                        ? WidgetUtils.settingsTile(
                            icon: Icons.delete,
                            title: translatedText(
                                "settings_delete_contacts", context),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(translatedText(
                                          "message_dialog_delete_contacts",
                                          context)),
                                      actions: <Widget>[
                                        FlatButton(
                                            child: Text(
                                              translatedText(
                                                  "button_close", context),
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }),
                                        FlatButton(
                                            child: Text(
                                              translatedText(
                                                  "button_ok", context),
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                            onPressed: () async {
                                              bool isDataDeleted =
                                                  await _db.deleteAllContacts();
                                              if (isDataDeleted) {
                                                _scaffoldKey.currentState
                                                    .showSnackBar(snackBar(
                                                        translatedText(
                                                            "snackbar_contact_delete_all",
                                                            context)));
                                                setState(() {
                                                  importedContacts = false;
                                                  prefs.setBool(
                                                      'importedContacts',
                                                      importedContacts);
                                                });
                                                contactService.removeAll();
                                              }

                                              Navigator.pop(context);
                                            })
                                      ],
                                    );
                                  });
                            })
                        : SizedBox(),
                    contactService.current.length > 0
                        ? WidgetUtils.settingsTile(
                            icon: Icons.content_cut,
                            title: translatedText(
                                "settings_delete_contacts_duplicate", context),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(translatedText(
                                          "message_dialog_delete_duplicate_contacts",
                                          context)),
                                      actions: <Widget>[
                                        FlatButton(
                                            child: Text(
                                              translatedText(
                                                  "button_close", context),
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            }),
                                        FlatButton(
                                            child: Text(
                                              translatedText(
                                                  "button_ok", context),
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                            onPressed: () async {
                                              await _db
                                                  .deleteDuplicateContacts();

                                              _scaffoldKey.currentState
                                                  .showSnackBar(snackBar(
                                                      translatedText(
                                                          "snackbar_contact_delete_duplicate",
                                                          context)));

                                              Navigator.pop(context);
                                            })
                                      ],
                                    );
                                  });
                            })
                        : SizedBox(),
                    contactService.current.length > 0
                        ? ExportSettings()
                        : SizedBox(),
                    ColorSettings(),
                    WidgetUtils.settingsTile(
                        title: 'blocked',
                        icon: Icons.block,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BlockedContactsActivity()),
                          );
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
