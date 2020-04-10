import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

import 'item.dart';

class FacebookItem extends MultaccItem {
  String username;
  String userId;

  FacebookItem();

  FacebookItem.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        userId = json['id'];

  toMap() => {'username': username, 'userId': userId};

  get humanReadableValue => username ?? (userId != null ? 'fb.com/$userId' : '');

  get type => MultaccItemType.Facebook;

  launchApp() async {
    try {
      await launch('fb://profile/$userId');
    } catch (ex) {
      launch('https://facebook.com/${username ?? userId}');
    }
  }

  launchMessenger() async {
    try {
      await launch('fb-messenger://user/${username ?? userId}');
    } catch (ex) {
      launch('https://facebook.com/messages/t/${username ?? userId}');
    }
  }

  get isLaunchable => true;

  set value(String input) {
    String domain = input.toLowerCase().split('/')[0];

    if (domain.contains('fb.me') || domain.contains('m.me')) {
      username = input.split('/').last;
    } else if (input.contains('profile.php?id=')) {
      userId = input.split('id=')[1];
    } else if (domain.contains('facebook.com') || domain.contains('fb.com')) {
      username = input.split('/').last;
    } else {
      username = input;
    }

    if (userId == null) _fetchId();
  }

  void _fetchId() async {
    final response = parse((await http.Client().get('https://facebook.com/$username')).body);
    final meta = response.head.getElementsByTagName('meta').firstWhere((meta) => meta.attributes['property'] == 'al:android:url');
    userId = meta.attributes['content'].split('/').last;
  }
}
