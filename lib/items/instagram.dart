import 'package:url_launcher/url_launcher.dart';

import 'item.dart';

class InstagramItem extends MultaccItem {
  String username;
  String userId;

  InstagramItem();

  InstagramItem.fromJson(Map<String, dynamic> json)
      : username = json['at'],
        userId = json['id'];

  toMap() => {'at': username, 'id': userId};

  get humanReadableValue => (username == null || username.trim() == '') ? '' : '@$username';

  get type => MultaccItemType.Instagram;

  launchApp() => launch('https://www.instagram.com/$username');

  get isLaunchable => true;

  set value(String input) {
    username = input.substring(input.startsWith('@') ? 1 : 0);
    // @todo Detect Instagram ID from username
  }
}
