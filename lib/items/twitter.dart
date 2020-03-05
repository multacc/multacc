import 'item.dart';

class TwitterItem extends MultaccItem {
  String username;
  String userId;

  TwitterItem.fromJson(Map<String, dynamic> json)
    : username = json['at'],
      userId = json['id'];

  Map<String, dynamic> toJson() =>
    {
      'at': username,
      'id': userId
    };

  @override
  String getHumanReadableType() {
    return 'Twitter';
  }

  @override
  String getHumanReadableValue() {
    return '@' + username;
  }

  @override
  MultaccItemType getType() {
    return MultaccItemType.Twitter;
  }

  @override
  void launchApp() {
    // @todo Implement Twitter launching
  }

  @override
  bool isLaunchable() {
    return true;
  }
}