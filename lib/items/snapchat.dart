import 'package:url_launcher/url_launcher.dart';

import 'item.dart';

class SnapchatItem extends MultaccItem {
  String username;

  SnapchatItem();

  SnapchatItem.fromJson(Map<String, dynamic> json) : username = json['at'];

  toMap() => {'at': username};

  get humanReadableValue => '@${username ?? ''}';

  get type => MultaccItemType.Snapchat;

  launchApp() => launch('https://www.snapchat.com/add/$username');

  get isLaunchable => true;

  set value(String input) {
    username = input.substring(input.startsWith('@') ? 1 : 0).trim();
  }
}
