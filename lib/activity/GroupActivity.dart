import 'package:flutter/material.dart';
import 'package:mycontacts_free/ContactDb.dart';
import 'package:mycontacts_free/activity/ContactListGroup.dart';
import 'package:mycontacts_free/activity/Settings.dart';
import 'package:mycontacts_free/utils/utils.dart';
import 'package:strings/strings.dart';
import 'dart:async';

import '../contact.dart';

class GroupActivity extends StatefulWidget {
  @override
  _GroupActivityState createState() {
    return _GroupActivityState();
  }
}

class _GroupActivityState extends State<GroupActivity> {
  final ContactDb db = ContactDb();
  Future<List<Contact>> contacts;
  List<String> category;

  @override
  void initState() {
    super.initState();
  }

  void _menuSelected(choice) {
    switch (choice) {
      case 'settings':
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Settings()),
          );
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    category = <String>[
      translatedText("group_default", context),
      translatedText("group_family", context),
      translatedText("group_friend", context),
      translatedText("group_coworker", context),
    ];
    return Scaffold(
      body: Container(
        child: ListView.builder(
            itemCount: category.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  // index % 10 == 0 ? AdmobUtils.admobBanner() : SizedBox(),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      // leading:
                      title: Text(
                        '${capitalize(category[index])}',
                        style: TextStyle(fontSize: 22),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        print("GROUP: ${category[index]}");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ContactListGroup(category: category[index])),
                        );
                        // }));
                      },
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
