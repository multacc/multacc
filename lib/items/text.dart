import 'package:contacts_service/contacts_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'item.dart';

class TextItem extends MultaccItem {
  String text;

  TextItem();

  TextItem.fromJson(Map<String, dynamic> json) : text = json['v'];

  toMap() => {'v': text};

  get humanReadableValue => text ?? '';

  get type => MultaccItemType.Text;

  get isLaunchable => false;

  set value(String input) {
    text = input;
  }
}
