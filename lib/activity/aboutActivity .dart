import 'package:flutter/material.dart';
import 'package:mycontacts_free/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

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
      appBar: AppBar(title: Text(translatedText("app_title_about", context))),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _title(translatedText("about_title", context)),
              _text(translatedText("about1", context), context),
              _text(translatedText("about2", context), context),
              _text(translatedText("about3", context), context),
              _text(translatedText("about4", context), context),
              _text(translatedText("about5", context), context),
              _text(translatedText("about6", context), context),
              _text(translatedText("about7", context), context),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    translatedText("button_rate", context),
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  onPressed: () async {
                    String url =
                        "https://play.google.com/store/apps/details?id=com.kevinrmendez.contact_app";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
