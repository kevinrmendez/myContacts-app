import 'package:admob_flutter/admob_flutter.dart';

import 'package:flutter/material.dart';

import '../apikeys.dart';

class AdmobUtils {
  static int _addCounter = 0;
  static int _addCounterDetails = 0;
  static String getAppId() {
    return apikeys["appId"];
  }

  static String getBannerAdUnitId() {
    return apikeys["addMobBanner"];
  }

  static String getInterstitialAdUnitId() {
    return apikeys["addMobInterstellar"];
  }

  static Widget admobBanner() {
    return AdmobBanner(
      adUnitId: getBannerAdUnitId(),
      adSize: AdmobBannerSize.BANNER,
    );
  }

  static AdmobInterstitial getInterstitialAd() {
    return AdmobInterstitial(adUnitId: getInterstitialAdUnitId());
  }

  static showInterstitialAd(AdmobInterstitial add) async {
    print("ADD : $_addCounter");
    if (_addCounter % 3 == 0) {
      if (await add.isLoaded) {
        add.show();
      }
    }
    _addCounter++;
  }

  static showInterstitialAdDetails(AdmobInterstitial add) async {
    print("ADD DETAILS: $_addCounterDetails");
    if (_addCounterDetails % 3 == 0) {
      if (await add.isLoaded) {
        add.show();
      }
    }
    _addCounterDetails++;
  }
}
