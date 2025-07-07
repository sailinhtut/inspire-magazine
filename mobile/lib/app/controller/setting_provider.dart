// ignore_for_file: no_leading_underscores_for_local_identifiers,

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspired_blog/main.dart';

class SettingProvier extends ChangeNotifier {
  bool allowNotification = true;
  bool allowCrossMeetNotification = true;

  bool trackingService = true;
  bool hideTrackServiceNoti = false;
  bool hideReportOnMap = false;

  Locale currentLocale = const Locale("en", "US");

  SettingProvier() {
    loadData();
  }

  void loadData() {
    final _allowNotification = pref.getBool('allowNotification');
    if (_allowNotification != null) {
      allowNotification = _allowNotification;
    } else {
      pref.setBool('allowNotification', true);
    }

    final _allowCrossMeetNotification =
        pref.getBool('allowCrossMeetNotification');
    if (_allowCrossMeetNotification != null) {
      allowCrossMeetNotification = _allowCrossMeetNotification;
    } else {
      pref.setBool('allowCrossMeetNotification', true);
    }

    trackingService = pref.getBool('trackingService') ?? true;
    hideTrackServiceNoti = pref.getBool('hideTrackServiceNoti') ?? false;
    hideReportOnMap = pref.getBool('hideReportOnMap') ?? false;

    final currentLanguageCode = pref.getString('currentLocale') ?? "en";
    currentLocale = Locale(currentLanguageCode);
  }

  void update() => notifyListeners();

  void updateAllowNotification(bool value) {
    pref.setBool('allowNotification', value);
    allowNotification = value;
    notifyListeners();
  }

  void updateAllowCrossMeetNotification(bool value) {
    pref.setBool('allowCrossMeetNotification', value);
    allowCrossMeetNotification = value;
    notifyListeners();
  }

  void updateTrackingService(bool value) {
    pref.setBool('trackingService', value);
    trackingService = value;
    notifyListeners();
  }

  void updateTrackingServiceNoti(bool value) {
    pref.setBool('hideTrackServiceNoti', value);
    hideTrackServiceNoti = value;
    notifyListeners();
  }

  void updateHideReportOnMap(bool value) {
    pref.setBool('hideReportOnMap', value);
    hideReportOnMap = value;
    notifyListeners();
  }

  void updateLocale(Locale newLocale) {
    currentLocale = newLocale;
    Get.updateLocale(newLocale);
    pref.setString('currentLocale', newLocale.languageCode);
    notifyListeners();
  }
}
