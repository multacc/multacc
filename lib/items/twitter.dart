import 'package:flutter/material.dart';
import 'package:flutter_brand_icons/flutter_brand_icons.dart';

import 'item.dart';

class TwitterItem extends MultaccItem {
  String username;
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

  bool isLaunchable() => true;

  getIcon() => Icon(BrandIcons.twitter);
}
