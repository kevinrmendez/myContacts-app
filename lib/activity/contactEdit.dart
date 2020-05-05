import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mycontacts_free/components/contactEditForm.dart';
import 'package:mycontacts_free/components/contactImage.dart';
import 'package:mycontacts_free/utils/admobUtils.dart';

import 'package:mycontacts_free/contact.dart';

class ContactEdit extends StatelessWidget {
  final Contact contact;
  final int index;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ContactEdit({@required this.contact, this.index});
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // contact = ModalRoute.of(context).settings.arguments;
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(children: <Widget>[
        ListView(
          controller: scrollController,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ContactEditForm(
                    contact: contact,
                    context: context,
                    index: index,
                    scrollController: scrollController),
                Positioned(top: 0, child: AdmobUtils.admobBanner())
              ],
            )
          ],
        ),
        Positioned(
            top: 75,
            left: -2,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ))
      ]),
    );
  }
}
