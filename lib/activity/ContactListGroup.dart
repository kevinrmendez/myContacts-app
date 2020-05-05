import 'package:flutter/material.dart';
import 'package:mycontacts_free/ContactDb.dart';
import 'package:mycontacts_free/activity/contactEdit.dart';
import 'package:mycontacts_free/state/appState.dart';
import 'package:mycontacts_free/utils/admobUtils.dart';
import 'package:mycontacts_free/utils/colors.dart';
import 'package:mycontacts_free/utils/utils.dart';
import 'package:mycontacts_free/utils/widgetUitls.dart';
import 'package:strings/strings.dart';
import 'dart:async';
import 'dart:io';

import '../apikeys.dart';
import '../contact.dart';
import 'Settings.dart';

import 'package:admob_flutter/admob_flutter.dart';

class ContactListGroup extends StatefulWidget {
  final String category;
  ContactListGroup({this.category});
  @override
  _ContactListGroupState createState() {
    return _ContactListGroupState();
  }
}

class _ContactListGroupState extends State<ContactListGroup> {
  int contactListLength = 0;
  _ContactListGroupState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List<Contact> names = List<Contact>();
  List<Contact> filteredNames = List<Contact>();

  List<Contact> _getContacts() {
    List<Contact> tempList = List<Contact>();
    tempList = contactService.current;

    var filteredList = tempList
        .where((contact) => contact.category == widget.category)
        .toList();

    setState(() {
      names = filteredList;
      filteredNames = names;
      contactListLength = names.length;
    });
    return tempList;
  }

  Widget _buildList() {
    if ((_searchText.isNotEmpty)) {
      List<Contact> tempList = new List<Contact>();
      for (int i = 0; i < filteredNames.length; i++) {
        print("FILTERED NAMES $filteredNames[i]");
        if (filteredNames[i].name != null) {
          if (filteredNames[i]
              .name
              .toLowerCase()
              .contains(_searchText.toLowerCase())) {
            tempList.add(filteredNames[i]);
          }
        }
      }
      filteredNames = tempList;
    }
    if (filteredNames.length > 0 || names.length > 0) {
      return ListView.builder(
          itemCount: names == null ? 0 : filteredNames.length,
          itemBuilder: (BuildContext context, int index) {
            if (filteredNames[index].name != null ||
                filteredNames[index].name == "") {
              return Column(
                children: <Widget>[
                  // index % 10 == 0 ? AdmobUtils.admobBanner() : SizedBox(),
                  WidgetUtils.contactListTile(
                      index, filteredNames[index], context)
                ],
              );
            } else {
              return SizedBox();
            }
          });
    } else {
      if (contactListLength == 0) {
        return WidgetUtils.emptyListText(
            title: translatedText("text_empty_list_group", context),
            context: context);
      } else {
        return Center(child: CircularProgressIndicator());
      }
    }
  }

  @override
  void initState() {
    _getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(capitalize(widget.category)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings()));
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          contactListLength > 2
              ? WidgetUtils.contactSearchTextField(
                  context: context, filter: _filter)
              : SizedBox(),
          Expanded(
            child: _buildList(),
          ),
        ],
      ),
    );
  }
}
