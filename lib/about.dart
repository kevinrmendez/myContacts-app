import 'package:flutter/material.dart';

class AboutActivity extends StatelessWidget {
  const AboutActivity({Key key}) : super(key: key);

  _text(String text, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _title(String text) {
      return Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Icon(
              Icons.info,
              color: Theme.of(context).primaryColor,
              size: 60,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[],
          ),
        ),
      ),
    );
  }
}
