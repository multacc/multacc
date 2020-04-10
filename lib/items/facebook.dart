import 'package:url_launcher/url_launcher.dart';

import 'item.dart';

class FacebookItem extends MultaccItem {
  String url;
  String pageName;

  FacebookItem();

  FacebookItem.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        pageName = json['page'];

  toMap() => {'url': url, 'page': pageName};

  get humanReadableValue => 'fb/$pageName';

  get type => MultaccItemType.Facebook;

  launchApp() async {
    try {
      await launch('fb://profile/$pageName');
    } catch (ex) {
      launch(url);
    }
  }

  launchMessenger() async {
    try {
      await launch('fb-messenger://user/$pageName');
    } catch (ex) {
      launch('https://facebook.com/messages/t/$pageName');
    }
  }

  get isLaunchable => true;

  set value(String input) {
    url = input;
    input = input.toLowerCase();
    if (input.contains('fb.me') || input.contains('m.me')) {
      pageName = input.split('me/')[1];
    } else if (input.contains('profile.php?id=')) {
      pageName = input.split('id=')[1];
    } else if (input.contains('facebook.com/')) {
      pageName = input.split('.com/')[1];
    } else {
      pageName = input;
    }
  }
}
