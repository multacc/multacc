import 'package:android_intent/android_intent.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:multacc/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'item.dart';

class PhoneItem extends MultaccItem {
  String phone;
  String label;

  PhoneItem.fromJson(Map<String, dynamic> json) : phone = json['no'], label = json['label'];

  PhoneItem.fromItem(Item item) : phone = item.value, label = item.label;

  Map<String, dynamic> toMap() => {'no': phone, 'label': label};

  String getHumanReadableType() => 'Phone';

  String getHumanReadableValue() => phone; // @todo Format phone numbers

  MultaccItemType getType() => MultaccItemType.Phone;

  /// Dials number in the preferred app
  void launchApp() {
    SharedPreferences prefs = GetIt.I.get<SharedPreferences>();
    switch (prefs.getString('PHONE_APP')) {
      case 'voice':
        AndroidIntent(
          action: 'android.intent.action.DIAL',
          data: 'tel:$phone',
          package: GOOGLE_VOICE_PACKAGE,
          componentName: GOOGLE_VOICE_INTENT_ACTIVITY,
        ).launch();
        break;
      case 'duo':
        AndroidIntent(
          action: '$GOOGLE_DUO_PACKAGE.action.CALL',
          data: 'tel:$phone',
          package: GOOGLE_DUO_PACKAGE,
        ).launch();
        break;
      case 'default':
      default:
        launch('tel:$phone');
        break;
    }
  }

  bool isLaunchable() => true;

  @override
  getIcon() => Icon(Icons.phone);
}
