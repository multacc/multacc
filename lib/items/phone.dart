import 'package:contacts_service/contacts_service.dart';

import 'item.dart';

class PhoneItem extends MultaccItem {
  String phone;

  PhoneItem.fromJson(Map<String, dynamic> json) : phone = json['no'];

  PhoneItem.fromItem(Item item) : phone = item.toString();

  Map<String, dynamic> toMap() => {'no': phone};

  String getHumanReadableType() => 'Phone';

  String getHumanReadableValue() => phone; // @todo Format phone numbers

  MultaccItemType getType() => MultaccItemType.Phone;

  void launchApp() {
    // @todo Implement phone launching
  }

  bool isLaunchable() => true;
}
