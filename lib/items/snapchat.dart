import 'package:url_launcher/url_launcher.dart';

import 'item.dart';

class SnapchatItem extends MultaccItem {
  String username;

  SnapchatItem();

  SnapchatItem.fromJson(Map<String, dynamic> json) : username = json['username'];

  toMap() => {'username': username};

  get humanReadableValue => '@${username ?? ''}';

  get type => MultaccItemType.Snapchat;

  launchApp() => launch('https://www.snapchat.com/add/$username');

  get isLaunchable => true;

  set value(String input) {
    username = input.trim().substring(input.startsWith('@') ? 1 : 0);
  }
}
