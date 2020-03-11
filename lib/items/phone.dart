import 'package:contacts_service/contacts_service.dart';
import 'package:hive/hive.dart';
import 'item.dart';

part 'phone.g.dart';

@HiveType(typeId: 2)
class PhoneItem extends MultaccItem {
  @HiveField(1)
  String phone;

  PhoneItem.fromJson(Map<String, dynamic> json) : phone = json['no'];

  PhoneItem.fromItem(Item item) : phone = item.toString();

  Map<String, dynamic> toMap() => {'no': phone};

  String getHumanReadableType() => 'Phone';

  String getHumanReadableValue() => phone; // @todo Format phone numbers

  MultaccItemType getType() => MultaccItemType.Phone;

  PhoneItem();

  void launchApp() {
    // @todo Implement phone launching
  }

  bool isLaunchable() => true;
}
