import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycontacts_free/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class BlockedContactsActivity extends StatefulWidget {
  static const platform = const MethodChannel('myContacts/blockedContacts');

  @override
  _BlockedContactsActivityState createState() =>
      _BlockedContactsActivityState();
}

class _BlockedContactsActivityState extends State<BlockedContactsActivity> {
  String hello = "";
  String _helloFromNative = "";
  String numberString = "SDF";
  String _numberFromNative = "";
  Future<void> _getText() async {
    try {
      _helloFromNative =
          await BlockedContactsActivity.platform.invokeMethod("getText");
    } on PlatformException catch (e) {
      _helloFromNative = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      hello = _helloFromNative;
    });
  }

  Future<void> _addBlockedNumber(int number) async {
    _numberFromNative = await BlockedContactsActivity.platform
        .invokeMethod("addBlockedNumber", {"number": number});

    setState(() {
      numberString = _numberFromNative;
    });
  }

  Future<void> _launchBlockedNumber() async {
    _numberFromNative = await BlockedContactsActivity.platform
        .invokeMethod("launchBlockedNumber");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(hello),
            Text(numberString),
            RaisedButton(
              child: Text('hello'),
              onPressed: () {
                _addBlockedNumber(123456789);
                _getText();
                _launchBlockedNumber();
              },
            ),
          ],
        ),
      ),
    );
  }
}
