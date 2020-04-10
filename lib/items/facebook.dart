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

  toMap() => {'username': username, 'id': userId};

  get humanReadableValue => (username ?? '') != '' ? username : (userId != null ? 'fb.com/$userId' : '');

  get _validUsernameOrId => (username ?? '') == '' ? userId : username;

  get type => MultaccItemType.Facebook;

  launchApp() async {
    try {
      await launch('fb://profile/$userId');
    } catch (ex) {
      launch('https://facebook.com/$_validUsernameOrId');
    }
  }

  launchMessenger() async {
    try {
      await launch('fb-messenger://user/$_validUsernameOrId');
    } catch (ex) {
      launch('https://facebook.com/messages/t/$_validUsernameOrId');
    }
  }

  get isLaunchable => true;

  set value(String input) {
    Uri url = Uri.parse(input);

    if (url.host.contains('fb.me') || url.host.contains('m.me')) {
      username = url.pathSegments.last;
    } else if (url.path.contains('profile.php')) {
      userId = url.queryParameters['id'];
    } else if (url.host.contains('facebook.com') || url.host.contains('fb.com')) {
      username = url.pathSegments.last;
    } else {
      username = input.trim();
    }

    if (userId == null) _fetchId();
  }

  void _fetchId() async {
    final response = parse((await http.Client().get('https://facebook.com/$username')).body);
    final meta = response.head.getElementsByTagName('meta').firstWhere((meta) => meta.attributes['property'] == 'al:android:url');
    userId = meta.attributes['content'].split('/').last;
  }
}
