import 'package:contacts_service/contacts_service.dart';
import 'package:hive/hive.dart';

import 'item.dart';

part 'email.g.dart';

@HiveType(typeId: 1)
class EmailItem extends MultaccItem {
  @HiveField(1)
  String email;

  EmailItem.fromJson(Map<String, dynamic> json) : email = json['email'];

  EmailItem.fromItem(Item item) : email = item.toString();

  Map<String, dynamic> toMap() => {'email': email};

  String getHumanReadableType() => 'Email';

  String getHumanReadableValue() => email;

  MultaccItemType getType() => MultaccItemType.Email;

  void launchApp() {
    // @todo Implement email launching
  }

  EmailItem();

  bool isLaunchable() => true;
}
