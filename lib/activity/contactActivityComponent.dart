import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mycontacts_free/activity/Settings.dart';
import 'package:mycontacts_free/components/contactImage.dart';
import 'package:mycontacts_free/components/contactImage.dart';
import 'package:mycontacts_free/components/contactImage.dart';
import 'dart:async';
import 'package:mycontacts_free/components/contact_form.dart';
import 'package:flutter/services.dart';
import 'package:mycontacts_free/contact.dart';
import 'package:mycontacts_free/contactDb.dart';
import 'package:mycontacts_free/state/appState.dart';
import 'package:mycontacts_free/utils/admobUtils.dart';
import 'package:mycontacts_free/utils/colors.dart';
import 'package:mycontacts_free/utils/utils.dart';
import 'package:mycontacts_free/utils/widgetUitls.dart';
import 'package:permission_handler/permission_handler.dart';

import '../app_localizations.dart';
import 'cameraActivity.dart';

class ContactActivityComponent extends StatefulWidget {
  final PermissionHandler _permissionHandler = PermissionHandler();
  final _formKey = GlobalKey<FormState>();
  final BuildContext context;

  ContactActivityComponent(BuildContext this.context);

  @override
  ContactActivityComponentState createState() =>
      ContactActivityComponentState();

  Future<bool> _requestCameraPermission() async {
    var result =
        await _permissionHandler.requestPermissions([PermissionGroup.camera]);

    if (result[PermissionGroup.contacts] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}

class ContactActivityComponentState extends State<ContactActivityComponent>
    with WidgetsBindingObserver {
  String _image = "";
  AppLifecycleState appState;
  AppLifecycleState appLifecycleState;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final ContactDb db = ContactDb();
  List<String> category;

  String action = "save";
  String image;
  String name;
  String phone;
  String email;
  int contactId;
  String dropdownValue;

  callback(value) {
    setState(() {
      _image = value;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
    category = <String>[
      translatedText("group_default", widget.context),
      translatedText("group_family", widget.context),
      translatedText("group_friend", widget.context),
      translatedText("group_coworker", widget.context),
    ];
    dropdownValue = category[0];
    contactId = 0;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState appLifecycleState) {
    appState = appLifecycleState;
    print(appLifecycleState);
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

  Future<void> _saveContact(Contact contact) async {
    await db.insertContact(contact);

    Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(translatedText("snackbar_contact_save", context))));
    _resetFormFields();
    // contactId++;
    print(contact);
    print(contactId);
    print(contact.email);
  }

  void _resetFormFields() {
    nameController.text = "";
    phoneController.text = "";
    emailController.text = "";

    image = "";
    setState(() {
      dropdownValue = category[0];
    });
  }

  _buildCamera() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 0),
        child: RaisedButton(
          color: Theme.of(context).accentColor,
          onPressed: () async {
            var permissionStatus = await widget._permissionHandler
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
                  setState(() {
                    _image = image;
                  });
                  // widget.callback(image);
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          translatedText("message_picture_taken", context))));
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ContactImage(
                image: _image,
              ),
              Positioned(top: 0, child: AdmobUtils.admobBanner()),
              Positioned(bottom: 5, child: _buildCamera())
            ],
          ),
          Align(
              alignment: Alignment.center,
              child: Form(
                  key: widget._formKey,
                  child: Container(
                    width: 250,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                              hintText:
                                  translatedText("hintText_name", context),
                              icon: Icon(Icons.person)),
                          controller: nameController,
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
                              hintText:
                                  translatedText("hintText_phone", context),
                              icon: Icon(Icons.phone)),
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'Please enter the phone';
                          //   }
                          //   return null;
                          // },
                          keyboardType: TextInputType.phone,
                          controller: phoneController,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText:
                                  translatedText("hintText_email", context),
                              icon: Icon(Icons.email)),
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
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
                              Container(
                                child: RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () async {
                                    // print('SAVIIIING');
                                    // print(widget.nameController);
                                    if (widget._formKey.currentState
                                        .validate()) {
                                      String name = nameController.text;
                                      String formattedName =
                                          '${name[0].toUpperCase()}${name.substring(1)}';
                                      Contact contact = Contact(
                                          // id: contactId,
                                          name: formattedName,
                                          phone: phoneController.text,
                                          email: emailController.text,
                                          category: dropdownValue,
                                          image: image);
                                      _saveContact(contact);
                                      print("CONTACTID: ${contact.id}");
                                      contactService.add(contact);
                                      // widget.callback("");
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
                  )),
        ],
      ),
    );
  }
}
