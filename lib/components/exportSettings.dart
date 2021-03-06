import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mycontacts_free/contactDb.dart';
import 'package:mycontacts_free/utils/admobUtils.dart';
import 'package:mycontacts_free/utils/colors.dart';
import 'package:mycontacts_free/utils/utils.dart';
import 'package:mycontacts_free/utils/widgetUitls.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vcard/vcard.dart';
import 'package:pdf/widgets.dart' as p;

final ContactDb db = ContactDb();
final _scaffoldKey = GlobalKey<ScaffoldState>();
final snackBar = (text) => SnackBar(content: Text(text));

class ExportSettings extends StatefulWidget {
  @override
  _ExportSettingsState createState() => _ExportSettingsState();
}

class _ExportSettingsState extends State<ExportSettings> {
  PermissionStatus _permissionStatus;
  Future<PermissionStatus> _checkPermission(
      PermissionGroup permissionGroup) async {
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(permissionGroup);
    return permission;
  }

  Future<Map<PermissionGroup, PermissionStatus>> _requestPermission(
      PermissionGroup permissionGroup) async {
    _permissionStatus = await _checkPermission(permissionGroup);
    if (_permissionStatus != PermissionStatus.granted) {
      return await PermissionHandler().requestPermissions([permissionGroup]);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetUtils.settingsTile(
        icon: Icons.import_export,
        title: translatedText("settings_export_contacts", context),
        onTap: () async {
          PermissionStatus status =
              await _checkPermission(PermissionGroup.storage);
          if (status == PermissionStatus.granted) {
            // _createContactCsv();
            WidgetUtils.showSnackbar(
                translatedText("snackbar_contact_exported", context), context);
          } else {
            Map<PermissionGroup, PermissionStatus> permission =
                await _requestPermission(PermissionGroup.storage);
            print(permission["permissionStatus"]);
            if (permission["permissionStatus"] == PermissionStatus.granted) {
              // _createContactCsv();
            } else {
              return null;
            }
          }
          showDialog(context: context, builder: (_) => ExportDialog());
        });
  }
}

class ExportDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WidgetUtils.dialog(
      title: translatedText("settings_export_contacts", context),
      context: context,
      height: MediaQuery.of(context).size.height * .6,
      child: ExportDialogContent(),
    );
    // return Dialog(
    //   child: Container(
    //     height: MediaQuery.of(context).size.height * .6,
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: <Widget>[
    //         Container(
    //             padding: EdgeInsets.symmetric(vertical: 14),
    //             width: MediaQuery.of(context).size.width,
    //             color: Theme.of(context).primaryColor,
    //             child: Text(
    //               translatedText("settings_export_contacts", context),
    //               textAlign: TextAlign.center,
    //               style: TextStyle(color: Colors.white, fontSize: 22),
    //             )),
    //         SizedBox(
    //           height: 10,
    //         ),
    //         ExportDialogContent(),
    //         SizedBox(
    //           height: 10,
    //         ),
    //         AdmobUtils.admobBanner()
    //       ],
    //     ),
    //   ),
    // );
  }
}

class ExportDialogContent extends StatefulWidget {
  final List<String> filepaths = [];
  @override
  _ExportDialogContentState createState() => _ExportDialogContentState();
}

class _ExportDialogContentState extends State<ExportDialogContent> {
  bool isPdfSelected;
  bool isCsvSelected;
  bool isVcfSelected;

  @override
  void initState() {
    super.initState();
    isPdfSelected = false;
    isCsvSelected = false;
    isVcfSelected = false;
  }

  void _exportContacts() {
    if (isPdfSelected) {
      _createPdf();
    }
    if (isCsvSelected) {
      _createContactCsv();
    }
    if (isVcfSelected) {
      _createVcard();
    }
    _sendEmail(filePaths: widget.filepaths);
  }

  Future<void> _sendEmail({List<String> filePaths}) async {
    Directory dir = await getExternalStorageDirectory();

    String path = dir.absolute.path;
    final Email email = Email(
      body: translatedText("text", context),
      subject: translatedText("email_csv_subject", context),
      // recipients: ['example@example.com'],
      attachmentPaths: [
        "$path/contacts.csv",
        "$path/example.pdf",
        "$path/contact.vcf"
      ],
    );
    await FlutterEmailSender.send(email);
    _scaffoldKey.currentState.showSnackBar(
        snackBar(translatedText("snackbar_contact_exported", context)));
  }

  void _createContactCsv() async {
    List<dynamic> contacts = await db.contacts();
    List<List<dynamic>> rows = List<List<dynamic>>();
    for (int i = 0; i < contacts.length; i++) {
      List<dynamic> row = List();
      row.add(contacts[i].name);
      row.add(contacts[i].phone);
      row.add(contacts[i].email);
      row.add(contacts[i].category);
      rows.add(row);
    }
    print('CONTACTS EXPORTED');
    Directory dir = await getExternalStorageDirectory();
    // var dir = await getApplicationDocumentsDirectory();

    String path = dir.absolute.path;
    print(path);
    File file = File('${path}/contacts.csv');

    print(file);
    String csv = const ListToCsvConverter().convert(rows);

    file.writeAsString(csv);
    String filePath = '${path}/contacts.csv';
    widget.filepaths.add(filePath);
  }

  Future<List<dynamic>> _generateTable() async {
    List<dynamic> contacts = await db.contacts();
    List<p.Widget> rows = List();
    // List<p.Widget> row = List();

    p.Text _text(text) {
      return p.Text('$text ||', style: p.TextStyle(fontSize: 12));
    }

    for (int i = 0; i < contacts.length; i++) {
      var text = p.Row(
        children: [
          p.Text('${i + 1})', style: p.TextStyle(fontSize: 12)),
          _text('${contacts[i].name}'),
          _text('${contacts[i].phone}'),
          _text('${contacts[i].email}'),
        ],
      );

      rows.add(text);
    }
    return rows;
  }

  void _createPdf() async {
    Directory dir = await getExternalStorageDirectory();
    String path = dir.absolute.path;
    File file = File('${path}/example.pdf');

    print("PDF FILE: $file");
    final p.Document pdfDocument = p.Document();
    var data = await _generateTable();

    pdfDocument.addPage(p.MultiPage(header: (p.Context context) {
      return p.Header(
          level: 1,
          child: p.Text('MyContacts', style: p.TextStyle(fontSize: 20)));
    }, build: (p.Context context) {
      return data;
    }));
    file.writeAsBytesSync(pdfDocument.save());
    String filePath = '${path}/example.pdf';
    widget.filepaths.add(filePath);
  }

  void _createVcard() async {
    Directory dir = await getExternalStorageDirectory();
    String path = dir.absolute.path;

    File file = File('$path/contact.vcf');

    file.writeAsStringSync("", mode: FileMode.write);

    String content;

    var vCard = VCard();
    List<dynamic> contacts = await db.contacts();

    contacts.forEach((contact) {
      // var name;
      // var firstName;
      // var lastName;
      // if (contact.name != null) {
      // name = contact.name.split(" ");
      // print("CONTACT NAME: $name");
      // print(name.length);
      // firstName = name[0];
      // if (name.length > 1) {
      //   lastName = name[1];
      // } else {
      //   lastName = "";
      // }
      // } else {
      //   name = [];
      //   firstName = "";
      //   lastName = "";
      // }
      // print("CONTACT: ${contact}");
      vCard.firstName = contact.name == null ? "no name" : contact.name;
      // vCard.firstName = firstName;
      // vCard.middleName = 'MiddleName';
      // vCard.lastName = lastName;
      // vCard.organization = 'ActivSpaces Labs';
      // vCard.photo.attachFromUrl(
      //     'https://www.activspaces.com/wp-content/uploads/2019/01/ActivSpaces-Logo_Dark.png',
      //     'PNG');
      vCard.workPhone = contact.phone == null ? "no phone" : contact.phone;
      // vCard.birthday = DateTime.now();
      // vCard.jobTitle = 'Software Developer';
      vCard.email = contact.email == null ? "no email" : contact.email;
      // vCard.note = 'Notes on contact';

      content = vCard.getFormattedString();
      file.writeAsStringSync(content, mode: FileMode.append);
    });
    String filePath = '${path}/contact.vcf';
    widget.filepaths.add(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * .8,
                child: Text(
                  translatedText("settings_export_description", context),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CheckboxListTile(
                title: Text('pdf'),
                value: isPdfSelected,
                onChanged: (bool value) {
                  setState(() {
                    isPdfSelected = value;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('csv'),
                value: isCsvSelected,
                onChanged: (bool value) {
                  setState(() {
                    isCsvSelected = value;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('vcf'),
                value: isVcfSelected,
                onChanged: (bool value) {
                  setState(() {
                    isVcfSelected = value;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      translatedText("button_export", context),
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    onPressed: () {
                      _exportContacts();
                      Navigator.of(context).pop();
                    },
                  ),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      translatedText("button_close", context),
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
