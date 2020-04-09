import 'package:url_launcher/url_launcher.dart';
import 'item.dart';

class URLItem extends MultaccItem {
  String url;

  URLItem();

  URLItem.fromJson(Map<String, dynamic> json) : url = json['url'];

  toMap() => {'url': url};

  get humanReadableValue => url ?? '';

  get type => MultaccItemType.URL;

  launchApp() {
    launch(url);
  }

  get isLaunchable => true;

  set value(String address) {
    url = address;
  }
}
