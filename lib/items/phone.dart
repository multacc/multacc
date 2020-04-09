import 'package:android_intent/android_intent.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:get_it/get_it.dart';
import 'package:multacc/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'item.dart';

class PhoneItem extends MultaccItem {
  String phone;
  String label;

  PhoneItem();

  PhoneItem.fromJson(Map<String, dynamic> json)
      : phone = json['no'],
        label = json['label'];

  PhoneItem.fromItem(Item item)
      : phone = item.value,
        label = item.label;

  Item toItem() => Item(label: label, value: phone);

  toMap() => {'no': phone, 'label': label};

  get humanReadableValue => phone ?? ''; // @todo Format phone numbers

  get type => MultaccItemType.Phone;

  /// Dials number in the preferred app
  launchApp() {
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

  get isLaunchable => true;

  set value(String number) {
    phone = number;
    // @todo Allow adding phone number labels manually
  }
}

class PhoneConnector extends Connector {
  PhoneConnector();

  connect() {
    return true; // "is connection-based" to store in MultaccItem
  }

  get(dynamic isConnected) {
    // @todo Detect user's phone number
    //
  }
}
