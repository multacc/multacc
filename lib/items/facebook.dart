import 'package:url_launcher/url_launcher.dart';

import 'item.dart';

class FacebookItem extends MultaccItem {
  String url;

  FacebookItem();

  FacebookItem.fromJson(Map<String, dynamic> json)
      : url = json['url'];

  toMap() => {'url': url};

  get humanReadableValue => url;

  get type => MultaccItemType.Facebook;

  launchApp() => launch(url);

  get isLaunchable => true;

  set value(String input) {
    url = input;
  }
}
