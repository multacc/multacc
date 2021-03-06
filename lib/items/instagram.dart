import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'item.dart';

class InstagramItem extends MultaccItem {
  String username;
  String userId;

  InstagramItem();

  InstagramItem.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        userId = json['id'];

  toMap() => {'username': username, 'id': userId};

  get humanReadableValue => (username ?? '') == '' ? '' : '@$username';

  get type => MultaccItemType.Instagram;

  launchApp() async {
    try {
      await launch('instagram://user?username=$username');
    } catch (ex) {
      launch('https://instagram.com/$username');
    }
  }

  launchDirectMessage() async {
    try {
      // @todo Figure out how to get Instagram DM thread id and launch DM
      // await launch('instagram://direct?username=$username');
      launch('https://instagram.com/direct/inbox');
    } catch (ex) {
      launchApp();
    }
  }

  get isLaunchable => true;

  set value(String input) {
    username = input.trim().substring(input.trim().startsWith('@') ? 1 : 0);
    _fetchId();
  }

  void _fetchId() async {
    String searchUrl = 'https://www.instagram.com/web/search/topsearch/?context=user&count=0&query=';
    final response = jsonDecode((await http.Client().get(Uri.parse('$searchUrl$username'))).body);
    userId = response['users'][0]['user']['pk'];
  }
}
