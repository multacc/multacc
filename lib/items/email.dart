import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'item.dart';

class EmailItem extends MultaccItem {
  String email;

  EmailItem.fromJson(Map<String, dynamic> json) : email = json['email'];

  EmailItem.fromItem(Item item) : email = item.value;

  Map<String, dynamic> toMap() => {'email': email};

  String getHumanReadableType() => 'Email';

  String getHumanReadableValue() => email;

  MultaccItemType getType() => MultaccItemType.Email;

  void launchApp() {
    launch('mailto:$email');
  }

  bool isLaunchable() => true;

  getIcon() => Icon(Icons.email);
}
