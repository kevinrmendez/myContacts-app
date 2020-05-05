import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:mycontacts_free/state/appSettings.dart';
import 'package:mycontacts_free/state/appState.dart';
import 'package:mycontacts_free/utils/colors.dart';
import 'package:mycontacts_free/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:mycontacts_free/activity/cameraActivity.dart';
import 'package:mycontacts_free/contact.dart';
import 'package:mycontacts_free/ContactDb.dart';

import '../app_localizations.dart';

//NOT USED

class ContactForm extends StatefulWidget {
  final BuildContext context;
  final PermissionHandler _permissionHandler = PermissionHandler();
  String image;
  Function(String) callback;
  final nameController;
  final phoneController;
  final emailController;

  ContactForm(
      {this.image,
      this.callback,
      this.nameController,
      this.emailController,
      this.phoneController,
      this.context});

  Future<bool> _requestCameraPermission() async {
    var result =
        await _permissionHandler.requestPermissions([PermissionGroup.camera]);

    if (result[PermissionGroup.contacts] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  @override
  ContactFormState createState() {
    return ContactFormState();
  }
}

class ContactFormState extends State<ContactForm> {
  List<String> category;

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final ContactDb db = ContactDb();
  String action = "save";
  String image;
  String name;
  String phone;
  String email;
  int contactId;

  String dropdownValue;

  @override
  void initState() {
    super.initState();
    category = <String>[
      translatedText("group_default", widget.context),
      translatedText("group_family", widget.context),
      translatedText("group_friend", widget.context),
      translatedText("group_coworker", widget.context),
    ];

    // this.name = widget.nameController.text;
    // this.phone = widget.phoneController.text;
    // this.email = widget.emailController.text;
    dropdownValue = category[0];
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    // widget.nameController.dispose();
    // widget.phoneController.dispose();

    super.dispose();
  }

  Future _alertDialog(String text) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(text),
          );
        });
  }

  Widget _dropDown() {
    return DropdownButton(
      value: dropdownValue,
      icon: Icon(Icons.arrow_drop_down),
      items: category.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(color: GREY),
          ),
        );
      }).toList(),
      onChanged: (String value) {
        setState(() {
          dropdownValue = value;
        });
      },
    );
  }

  void _resetFormFields() {
    widget.nameController.text = "";
    widget.phoneController.text = "";
    widget.emailController.text = "";

    image = "";
    setState(() {
      dropdownValue = category[0];
    });
  }

  Future<void> _saveContact(Contact contact) async {
    await db.insertContact(contact);

    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(translatedText("snackbar_contact_save", context))));
    _resetFormFields();
    contactId++;
    print(contact);
    print(contactId);
    print(contact.email);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    AppSettings appState = AppSettings.of(context);
    return Form(
        key: _formKey,
        child: Container(
          width: 250,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    hintText: translatedText("hintText_name", context),
                    icon: Icon(Icons.person)),
                controller: widget.nameController,
                validator: (value) {
                  if (value.isEmpty) {
                    return translatedText(
                        "hintText_name_verification", context);
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: translatedText("hintText_phone", context),
                    icon: Icon(Icons.phone)),
                // validator: (value) {
                //   if (value.isEmpty) {
                //     return 'Please enter the phone';
                //   }
                //   return null;
                // },
                keyboardType: TextInputType.phone,
                controller: widget.phoneController,
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: translatedText("hintText_email", context),
                    icon: Icon(Icons.email)),
                keyboardType: TextInputType.emailAddress,
                controller: widget.emailController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.group,
                    color: GREY,
                    size: 25,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    translatedText("hintText_group", context),
                    style: TextStyle(
                      color: GREY,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  _dropDown()
                ],
              ),
              Container(
                // padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 0),
                        child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          onPressed: () async {
                            var permissionStatus = await widget
                                ._permissionHandler
                                .checkPermissionStatus(PermissionGroup.camera);
                            final cameras = await availableCameras();
                            final firstCamera = cameras.first;

                            switch (permissionStatus) {
                              case PermissionStatus.granted:
                                {
                                  image = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CameraActivity(
                                              camera: firstCamera,
                                            )),
                                  );
                                  widget.callback(image);
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(translatedText(
                                          "message_picture_taken", context))));
                                  print(image.toString());
                                }
                                break;
                              case PermissionStatus.denied:
                                {
                                  await widget._requestCameraPermission();
                                }
                                break;
                              default:
                            }
                          },
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        )),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      // width: 20,
                      // padding:
                      //     EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                      child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        onPressed: () async {
                          // print('SAVIIIING');
                          // print(widget.nameController);
                          if (_formKey.currentState.validate()) {
                            String name = widget.nameController.text;
                            String formattedName =
                                '${name[0].toUpperCase()}${name.substring(1)}';
                            Contact contact = Contact(
                                // id: contactId,
                                name: formattedName,
                                phone: widget.phoneController.text,
                                email: widget.emailController.text,
                                category: dropdownValue,
                                image: widget.image);
                            _saveContact(contact);
                            print("CONTACTID: ${contact.id}");
                            contactService.add(contact);
                            widget.callback("");
                          }
                          // print(await db.contacts());
                        },
                        child: Text(
                          translatedText("button_save", context),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ) // Build this out in the next steps.
        );
  }
}
