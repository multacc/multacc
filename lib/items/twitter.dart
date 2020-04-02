import 'item.dart';

class TwitterItem extends MultaccItem {
  String username;
  String userId;

  TwitterItem();

  TwitterItem.fromJson(Map<String, dynamic> json)
      : username = json['at'],
        userId = json['id'];

  toMap() => {'at': username, 'id': userId};

  get humanReadableValue => username == null ? '' : '@$username';

  get type => MultaccItemType.Twitter;

  launchApp() {
    // @todo Implement Twitter launching
  }

  get isLaunchable => true;

  set value(String input) {
    username = input.substring(input.startsWith('@') ? 1 : 0);
    // @todo Detect Twitter user ID from username
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
