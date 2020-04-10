import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

import 'item.dart';

class FacebookItem extends MultaccItem {
  String userId;

  String _username;
  get username => _username ?? '';
  set username(String input) {
    _username = input;
    _fetchId();
  }

  FacebookItem();

  FacebookItem.fromJson(Map<String, dynamic> json)
      : _username = json['username'],
        userId = json['id'];

  toMap() => {'username': username, 'id': userId};

  get humanReadableValue => username != '' ? username : (userId != null ? 'fb.com/$userId' : '');

  get _validUsernameOrId => username != '' ? username : userId;

  get type => MultaccItemType.Facebook;

  launchApp() async {
    if ((userId ?? '') != '') {
      try {
        await launch('fb://profile/$userId');
      } catch (e) {
        launch('https://facebook.com/$userId');
      }
    } else {
      launch('https://facebook.com/$username');
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

  // @todo Add 'value' getter for editing
  set value(String input) {
    Uri url;
    try {
      url = Uri.parse(input);
    } on FormatException {
      url = null;
    }
    String domain = url?.host ?? '';
    
    if (domain.startsWith('www.')) {
      domain = domain.substring(4);
    }
    if (url?.queryParameters?.containsKey('id') ?? false) {
      userId = url.queryParameters['id'];
      _fetchUsername();
    } else {
      String user = [
        'm.me', 
        'fb.me', 
        'fb.com', 
        'facebook.com',
      ].contains(domain) ? url.pathSegments[0] : input.trim();
      if (domain != 'fb.me' && RegExp(r'\d+').hasMatch(user)) {
        userId = user;
        _fetchUsername();
      } else {
        username = user;
        _fetchId();
      }
    }
  }
 
 void _fetchUsername() {
   // @todo Fetch Facebook username from id
 }
 
  // @todo More robust Facebook id fetching
  void _fetchId() async {
    final response = parse((await http.Client().get('https://facebook.com/$username')).body);
    final meta = response.head.getElementsByTagName('meta').firstWhere((meta) => meta.attributes['property'] == 'al:android:url');
    userId = meta.attributes['content'].split('/').last;
  }
}
