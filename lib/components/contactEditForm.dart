import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mycontacts_free/activity/ContactList2.dart';
import 'package:mycontacts_free/activity/Settings.dart';
import 'package:mycontacts_free/activity/cameraActivity.dart';
import 'package:mycontacts_free/main.dart';
import 'package:mycontacts_free/state/appSettings.dart';
import 'package:mycontacts_free/state/appState.dart';
import 'package:mycontacts_free/utils/colors.dart';
import 'package:mycontacts_free/utils/widgetUitls.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scidart/numdart.dart';
import 'package:mycontacts_free/components/contactImage.dart';
import 'package:mycontacts_free/utils/utils.dart';
import 'package:share/share.dart';

import 'package:mycontacts_free/contact.dart';
import 'package:mycontacts_free/ContactDb.dart';
import 'package:mycontacts_free/utils/admobUtils.dart';
import 'package:intl/intl.dart';
import '../main.dart';

class ContactEditForm extends StatefulWidget {
  final BuildContext context;
  final ScrollController scrollController;
  final Contact contact;
  final int index;
  final List<String> category = <String>[
    "general",
    "family",
    "friend",
    "coworker"
  ];
  final PermissionHandler _permissionHandler = PermissionHandler();
  final _formKey = GlobalKey<FormState>();

  ContactEditForm(
      {@required this.contact,
      this.context,
      this.index,
      this.scrollController});

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
  ContactEditFormState createState() {
    return ContactEditFormState();
  }
}

class ContactEditFormState extends State<ContactEditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  List<String> category;

  final ContactDb db = ContactDb();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final birthdayController = TextEditingController();
  final addressController = TextEditingController();
  final organizationController = TextEditingController();
  final websiteController = TextEditingController();
  final noteController = TextEditingController();
  final instagramController = TextEditingController();

  String name;
  String phone;
  String email;
  Contact contact;
  String image;
  int favorite;
  int showNotification;
  Future<List<Contact>> contacts;
  String birthday;
  String address;
  String organization;
  String website;
  String note;
  DateTime pickedDate;

  int sendedNotification;

  String dropdownValue;
  // bool isBirthdayNotificationEnable;
  bool showDetails;

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

  @override
  void initState() {
    super.initState();
    this.contact = widget.contact;

    this.name = widget.contact.name;
    this.phone = widget.contact.phone.toString();
    this.email = widget.contact.email;
    this.image = widget.contact.image;
    this.favorite = widget.contact.favorite;
    this.showNotification = widget.contact.showNotification;
    this.birthday = widget.contact.birthday;
    this.address = widget.contact.address;
    this.organization = widget.contact.organization;
    this.website = widget.contact.website;
    this.note = widget.contact.note;

    this.nameController.text = this.name;
    this.phoneController.text = this.phone;
    this.emailController.text = this.email;
    this.birthdayController.text = this.birthday;
    this.addressController.text = this.address;
    this.organizationController.text = this.organization;
    this.websiteController.text = this.website;
    this.noteController.text = this.note;

    category = <String>[
      translatedText("group_default", widget.context),
      translatedText("group_family", widget.context),
      translatedText("group_friend", widget.context),
      translatedText("group_coworker", widget.context),
    ];
    dropdownValue = contact.category;

    // isBirthdayNotificationEnable = false;
    showDetails = false;
  }

  Future<void> _updateContact(Contact contact) async {
    contact.name = nameController.text;
    contact.phone = phoneController.text;
    contact.email = emailController.text;
    contact.image = this.image;
    contact.favorite = this.favorite;
    contact.showNotification = this.showNotification;
    contact.category = this.dropdownValue;
    contact.birthday = this.birthday;
    contact.address = this.address;
    contact.organization = this.organization;
    contact.website = this.website;
    contact.note = this.note;

    // print('after update id');
    // print(contact);
    await db.updateContact(contact);

    contacts = db.contacts();
    // List contactsDb = await db.contacts();

    contactService.update(contact);
    _showMessage(translatedText("message_dialog_change_contact", context));
  }

  Future<void> _deleteContact(Contact contact) async {
    List<Contact> contactList;
    AppSettings appState = AppSettings.of(context);
    await db.deleteContact(contact.id);
    // List<Contact> contacts = await db.contacts();
    // print('Contacts AFTER DELETE $contacts');
    contacts = db.contacts();
    contactList = await contacts;
    contactService.remove(contact);
    int contactsLength = contactList.length;

    _showMessage(translatedText("message_dialog_contact_deleted", context));
  }

  void _showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            actions: <Widget>[
              FlatButton(
                  child: Text(
                    translatedText("button_close", context),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Home()),
                      (Route<dynamic> route) => false,
                    );
                  })
            ],
          );
        });
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(1980),
        firstDate: DateTime(1980),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (picked != null) {
      var formatter = DateFormat('dd/MM/yyyy');
      var formattedDate = formatter.format(picked);
      setState(() {
        pickedDate = picked;
        birthday = formattedDate.toString();
      });
      birthdayController.text = formattedDate.toString();
    }
  }

  Widget _buildForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Form(
            key: widget._formKey,
            child: Container(
              width: 280,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    onChanged: (value) {
                      this.name = value;
                      setState(() {
                        this.name = value;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: translatedText("hintText_name", context),
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
                    onChanged: (value) {
                      setState(() {
                        this.phone = value;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: translatedText("hintText_phone", context),
                        icon: Icon(Icons.phone)),
                    validator: (value) {
                      if (value.isEmpty) {
                        return translatedText(
                            "hintText_phone_verification", context);
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        this.email = value;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: translatedText("hintText_email", context),
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
                    height: 20,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          translatedText("hintText_favorite", context),
                          style: TextStyle(color: Colors.grey),
                        ),
                        Switch(
                          onChanged: (bool value) {
                            setState(() {
                              this.favorite = boolToInt(value);
                            });
                          },
                          value: intToBool(this.favorite),
                          // value: false,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 4),
                    child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      child: Text(
                        translatedText("button_contact_details", context),
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        setState(() {
                          showDetails = !showDetails;
                        });
                        if (showDetails) {
                          widget.scrollController.animateTo(
                              MediaQuery.of(context).size.height,
                              duration: Duration(seconds: 1),
                              curve: Curves.easeOut);
                        } else {
                          widget.scrollController.animateTo(0.0,
                              duration: Duration(seconds: 1),
                              curve: Curves.easeOut);
                        }
                      },
                    ),
                  ),
                  showDetails
                      ? Column(
                          children: <Widget>[
                            TextFormField(
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());

                                await _selectDate();
                              },
                              decoration: InputDecoration(
                                  hintText: translatedText(
                                      "hintText_birthday", context),
                                  icon: Icon(Icons.calendar_today)),
                              // keyboardType: TextInputType.datetime,
                              controller: birthdayController,
                            ),
                            birthday.length > 900000000000 //hide notification
                                // birthday.length > 0 //ORIGINAL notification
                                ? Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.notifications_active,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            // translatedText("hintText_favorite", context),
                                            translatedText(
                                                "hintText_birthday_notification",
                                                context),
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Switch(
                                            onChanged: (bool value) async {
                                              setState(() {
                                                this.showNotification =
                                                    boolToInt(value);
                                                // this.isBirthdayNotificationEnable = value;
                                              });
                                              print(
                                                  "SHOWNOTIFICATION: ${this.showNotification}");
                                              if (showNotification == 1) {
                                                await _sendBirthdayNotification(
                                                    title: translatedText(
                                                        "notification_birthday_title",
                                                        context),
                                                    description: translatedText(
                                                        "notification_birthday_description",
                                                        context),
                                                    payload: translatedText(
                                                        "notification_birthday_payload",
                                                        context));
                                                // flutterLocalNotificationsPlugin
                                                //     .cancel(contact.id);
                                              } else {
                                                print("CONTACTID: $contact.id");
                                                flutterLocalNotificationsPlugin
                                                    .cancel(contact.id);
                                              }
                                            },
                                            value: intToBool(
                                                this.showNotification),
                                            // value: false,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : SizedBox(),
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  this.address = value;
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: translatedText(
                                      "hintText_address", context),
                                  icon: Icon(Icons.location_city)),
                              keyboardType: TextInputType.text,
                              controller: addressController,
                            ),
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  this.organization = value;
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: translatedText(
                                      "hintText_organization", context),
                                  icon: Icon(Icons.store)),
                              keyboardType: TextInputType.text,
                              controller: organizationController,
                            ),
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  this.website = value;
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: translatedText(
                                      "hintText_website", context),
                                  icon: Icon(Icons.web)),
                              keyboardType: TextInputType.text,
                              controller: websiteController,
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    this.note = value;
                                  });
                                },
                                decoration: InputDecoration(
                                    hintText: translatedText(
                                        "hintText_note", context),
                                    icon: Icon(Icons.description)),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                controller: noteController,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  _buildFormButtons(),
                ],
              ),
            ) // Build this out in the next steps.
            ),
      ],
    );
  }

  Future _sendBirthdayNotification(
      {String title, String description, String payload}) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'notification_channel_id_birthday',
        'channelBirthday',
        'channel for sending notifications for birthdays remindings',
        importance: Importance.Max,
        priority: Priority.High);

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    // await flutterLocalNotificationsPlugin.show(
    //     0, 'birthday', 'it is your birthday', platformChannelSpecifics,
    //     payload: 'birthday');
    var birth_day = pickedDate.day;
    var birth_month = pickedDate.month;
    var notificationTime =
        DateTime(DateTime.now().year, birth_month, birth_day);
    // var notificationDate =
    //     DateTime.now().add(Duration(seconds: 10));
    await flutterLocalNotificationsPlugin.schedule(
        contact.id, // notification id,
        "$title ${contact.name}",
        '$description $pickedDate',
        // notificationDate,
        notificationTime,
        platformChannelSpecifics,
        payload: "${contact.id} $payload ${contact.name}!");
  }

  Widget _buildFormButtons() {
    List<Widget> _buttons = [
      RaisedButton(
        color: Theme.of(context).primaryColor,
        onPressed: () async {
          _updateContact(contact);
        },
        child: Text(
          translatedText("button_save", context),
          style: TextStyle(color: Colors.white),
        ),
      ),
      SizedBox(
        width: 20,
      ),
      RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Text(
          translatedText("button_delete", context),
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () async {
          await _deleteContact(contact);
        },
      ),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buttons,
    );
  }

  Widget _buildPreviewText() {
    return _buildBoldText(this.name);
  }

  Widget _buildBoldText(String text) {
    return Container(
      color: contact.image == null || contact.image == ""
          ? Colors.transparent
          : Colors.transparent,
      // : Theme.of(context).primaryColor,
      // padding: EdgeInsets.symmetric(vertical: 4),
      // width: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width * .75,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Flexible(
            // width: MediaQuery.of(context).size.width * .75,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: contact.image == null || contact.image == ""
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor),
              // : Colors.white),
            ),
          ),
          this.favorite == 1
              ? SizedBox(
                  width: 5,
                )
              : SizedBox(),
          SizedBox(
            height: 35,
            width: 35,
            child: this.favorite == 1
                ? Icon(
                    Icons.star,
                    color: contact.image == null || contact.image == ""
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor,
                    // : Colors.white,
                    size: 35,
                  )
                : SizedBox(),
          )
        ],
      ),
    );
  }

  Widget _buildShareButton() {
    return Container(
      width: 100,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Icon(
          Icons.share,
          color: Colors.white,
        ),
        onPressed: () {
          Share.share(
              "${translatedText("app_title_contactDetails", context)}: ${translatedText("hintText_name", context)} ${contact.name}, ${translatedText("hintText_phone", context)}: ${contact.phone}, ${translatedText("hintText_email", context)}: ${contact.email}");
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // contact = ModalRoute.of(context).settings.arguments;
    // Build a Form widget using the _formKey created above.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          // padding: EdgeInsets.symmetric(
          //     vertical:
          //         widget.contact.image == null || widget.contact.image == ""
          //             ? 0
          //             : 0
          //             ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  ContactImage(
                    context: context,
                    image: this.image,
                  ),
                  Positioned(bottom: 5, child: _buildCamera(context)),
                ],
              ),
              _buildPreviewText(),
            ],
          ),
        ),
        Container(
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              contact.phone != ""
                  ? WidgetUtils.urlButtons(
                      color: Theme.of(context).primaryColor,
                      url: "tel:${contact.phone.toString()}",
                      icon: Icon(
                        Icons.phone,
                        color: Colors.white,
                      ))
                  : const SizedBox(),
              contact.email != ""
                  ? WidgetUtils.urlButtons(
                      color: Theme.of(context).primaryColor,
                      url: 'mailto:${contact.email}',
                      icon: Icon(
                        Icons.email,
                        color: Colors.white,
                      ))
                  : const SizedBox(),
              _buildShareButton()
            ],
          ),
        ),
        _buildForm(),
        SizedBox(
          height: 20,
        )
      ],
    );
  }

  Widget _buildCamera(BuildContext context) {
    return Container(
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
      ),
    );
  }
}
