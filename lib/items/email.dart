import 'package:contacts_service/contacts_service.dart';

import 'item.dart';

class EmailItem extends MultaccItem {
  String email;

  EmailItem.fromJson(Map<String, dynamic> json) : email = json['email'];

  EmailItem.fromItem(Item item) : email = item.toString();

  Map<String, dynamic> toJson() => {'email': email};

  String getHumanReadableType() => 'Email';

  String getHumanReadableValue() => email;

  MultaccItemType getType() => MultaccItemType.Email;

  void launchApp() {
    // @todo Implement email launching
  }

  bool isLaunchable() => true;
}
