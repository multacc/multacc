import 'item.dart';
import 'package:hive/hive.dart';

part 'twitter.g.dart';

@HiveType(typeId: 3)
class TwitterItem extends MultaccItem {
  @HiveField(1)
  String username;
  @HiveField(2)
  String userId;

  TwitterItem.fromJson(Map<String, dynamic> json)
      : username = json['at'],
        userId = json['id'];

  Map<String, dynamic> toMap() => {'at': username, 'id': userId};

  String getHumanReadableType() => 'Twitter';

  String getHumanReadableValue() => '@$username';

  MultaccItemType getType() => MultaccItemType.Twitter;

  void launchApp() {
    // @todo Implement Twitter launching
  }

  TwitterItem();

  bool isLaunchable() => true;
}
