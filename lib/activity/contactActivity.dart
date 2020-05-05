import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mycontacts_free/activity/Settings.dart';
import 'package:mycontacts_free/activity/contactActivityComponent.dart';
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

class ContactActivity extends StatefulWidget {
  final PermissionHandler _permissionHandler = PermissionHandler();
  final _formKey = GlobalKey<FormState>();

  @override
  ContactActivityState createState() => ContactActivityState();

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

class ContactActivityState extends State<ContactActivity>
    with WidgetsBindingObserver {
  AppLifecycleState appState;
  AppLifecycleState appLifecycleState;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: ContactActivityComponent(context));
  }
}
