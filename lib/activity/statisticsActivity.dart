import 'package:flutter/material.dart';
import 'package:mycontacts_free/components/contactsPieChart.dart';
import 'package:mycontacts_free/contact.dart';
import 'package:mycontacts_free/state/appState.dart';
import 'package:mycontacts_free/utils/admobUtils.dart';
import 'package:mycontacts_free/utils/colors.dart';
import 'package:mycontacts_free/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class StatisticsActivity extends StatefulWidget {
  const StatisticsActivity({Key key}) : super(key: key);

  @override
  _StatisticsActivityState createState() => _StatisticsActivityState();
}

class _StatisticsActivityState extends State<StatisticsActivity> {
  List<Contact> contactList;
  int contactListLength = 0;
  int favoirteQuantity = 0;

  _checkFavoriteContacts() {
    contactList.forEach((contact) {
      if (contact.favorite == 1) {
        favoirteQuantity++;
      }
    });
  }

  _getCategoryContactsQuantity(String category) {
    int counter = 0;
    contactList.forEach((contact) {
      if (contact.category == category) {
        counter++;
      }
    });
    return counter;
  }

  _checkContactsDuplicates() {
    List<Contact> list = contactService.current;
    Contact contact;
    int duplicatesCounter = 0;
    list.forEach((current) {
      if (contact == null) {
        contact = current;
      } else {
        if (contact.name == current.name &&
            contact.phone == current.phone &&
            contact.email == current.email &&
            contact.favorite == current.favorite &&
            contact.category == current.category) {
          duplicatesCounter++;
        } else {
          contact = current;
        }
      }
    });
    print("DUPLICATES: $duplicatesCounter");
    int duplicatesNumber = duplicatesCounter;
    contactService.updateContactsDuplicate(duplicatesNumber);
  }

  @override
  void initState() {
    super.initState();
    contactList = contactService.current;
    contactListLength = contactService.current.length;
    _checkContactsDuplicates();
    _checkFavoriteContacts();
  }

  Widget _stadisticsTile({IconData icon, String text, int data}) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 20, 10),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 18,
            color: GREY,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            data.toString(),
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }

  Widget _boldText(text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(translatedText("app_title_statistics", context))),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _boldText(translatedText("title_statistics", context)),
            Container(
              padding: EdgeInsets.fromLTRB(15, 10, 20, 0),
              child: Column(
                children: <Widget>[
                  _stadisticsTile(
                      icon: Icons.person,
                      text: translatedText("statistics_total", context),
                      data: contactListLength),
                  _stadisticsTile(
                      icon: Icons.people,
                      text:
                          translatedText("statistics_total_duplicate", context),
                      data: contactService.currentContactsDuplicates),
                  _stadisticsTile(
                      icon: Icons.star,
                      text: translatedText("statistics_favorites", context),
                      data: favoirteQuantity),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            contactListLength > 0
                ? _boldText(translatedText("statistics_groups", context))
                : SizedBox(),
            Container(
                height: 350,
                // width: MediaQuery.of(context).size.width * .7,
                child: ContactsPieChart(
                  context,
                  animate: true,
                )),
            AdmobUtils.admobBanner(),
          ],
        ),
      ),
    );
  }
}
