import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mycontacts_free/state/appSettings.dart';
import 'package:mycontacts_free/utils/colors.dart';

class ContactImage extends StatelessWidget {
  final String image;
  final BuildContext context;
  const ContactImage({this.context, this.image});

  @override
  Widget build(context) {
    AppSettings appState = AppSettings.of(context);
    // print('MYTHEMEKEYS ${appState.themeKey}');

    return Container(
      padding: EdgeInsets.only(top: image == null || image == "" ? 0 : 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          image == null || image == ""
              ? Container(
                  // padding: EdgeInsets.only(top: 50),
                  height: MediaQuery.of(context).size.height * .42,
                  // height: 300,
                  child: Center(
                    // child: CircleAvatar(
                    //   radius: 85,
                    //   backgroundColor: Theme.of(context).primaryColor,
                    //   backgroundImage: image == "" || image == null
                    //       ? AssetImage('assets/person-icon-w-s3p.png')
                    //       : FileImage(File(image)),
                    // ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .24,
                      width: MediaQuery.of(context).size.height * .24,
                      // height: 0,
                      // width: 200,
                      // width: MediaQuery.of(context).size.width * .45,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: GREY,
                              offset: const Offset(3.0, 3.0),
                              blurRadius: 5.0,
                              spreadRadius: 2.0,
                            ),
                          ],
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(200))),
                      child: Container(
                          decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/person-icon-w-s3p.png'),
                            fit: BoxFit.scaleDown),
                      )),
                    ),
                    // backgroundColor: Theme.of(context).primaryColor,
                    // backgroundImage: image == "" || image == null
                    //     ? AssetImage('assets/person-icon-w-s3p.png')
                    //     : FileImage(File(image)),
                    // ),
                  ),
                )
              // ? Container(
              //     height: 300,
              //     width: MediaQuery.of(context).size.width,
              //     color: Theme.of(context).primaryColor,
              //     child: Center(
              //       child: Container(
              //           width: 190,
              //           height: 190,
              //           decoration: BoxDecoration(
              //             // borderRadius: BorderRadius.only(
              //             //     bottomLeft: Radius.circular(20),
              //             //     bottomRight: Radius.circular(20)),
              //             image: DecorationImage(
              //                 image: AssetImage('assets/person-icon-w-s3p.png'),
              //                 fit: BoxFit.scaleDown),
              //           )),
              //     ),
              //   )
              : Container(
                  height: MediaQuery.of(context).size.height * .42,
                  // height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.only(
                    //     bottomLeft: Radius.circular(20),
                    //     bottomRight: Radius.circular(20)),
                    image: DecorationImage(
                        image: FileImage(File(image)), fit: BoxFit.cover),
                  ))
        ],
      ),
    );
    // child: Image.file(File(image)));
  }
}
