import 'package:contacts_service/contacts_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'item.dart';

class EmailItem extends MultaccItem {
  String email;
  String label;

  EmailItem();

  EmailItem.fromJson(Map<String, dynamic> json)
    : email = json['email'],
      label = json['label'];

  EmailItem.fromItem(Item item)
    : email = item.value,
      label = item.label;

  Item toItem() => Item(label: label, value: email);

  toMap() => {'email': email, 'label': label};

  get humanReadableValue => email ?? '';

  get type => MultaccItemType.Email;

  launchApp() {
    launch('mailto:$email');
  }

  get isLaunchable => true;

  set value(String address) {
    email = address;
  }
}
