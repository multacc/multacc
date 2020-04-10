import 'package:url_launcher/url_launcher.dart';

import 'item.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class TwitterItem extends MultaccItem {
  String username;
  String userId;

  TwitterItem();

  TwitterItem.fromJson(Map<String, dynamic> json)
      : username = json['at'],
        userId = json['id'];

  toMap() => {'at': username, 'id': userId};

  get humanReadableValue => '@${username ?? ''}';

  get type => MultaccItemType.Twitter;

  launchApp() async {
    try {
      await launch('twitter://user?screen_name=$username');
    } catch (ex) {
      launch('https://twitter.com/$username');
    }
  }

  get isLaunchable => true;

  set value(String input) {
    username = input.substring(input.startsWith('@') ? 1 : 0).trim();
    _fetchId();
  }

  void _fetchId() async {
    final response = parse((await http.Client().get('http://gettwitterid.com/?user_name=$username')).body);
    final info = response.body.querySelector('div.info_container > table > tbody > tr');
    userId = info.children.last.getElementsByTagName('p')[0].text;
  }
}

class TwitterConnector extends Connector {
  TwitterConnector();

  connect() {
    // @todo Connect to twitter
    // return token
  }

  get(dynamic token) {
    // Get value from twitter
    TwitterItem item = TwitterItem();
    // set item username and userId
    return item;
  }
}
