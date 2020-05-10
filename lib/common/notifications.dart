import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:multacc/common/constants.dart';
import 'package:multacc/pages/chats/messages_page.dart';

enum NotificationType {
  Groupme,
}

class Notifications {
  Notifications._();
  static final Notifications instance = Notifications._();

  FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<bool> init(BuildContext context) async {
    return localNotificationsPlugin.initialize(
      InitializationSettings(
        AndroidInitializationSettings('ic_stat_multacc'),
        IOSInitializationSettings(),
      ),
      onSelectNotification: (payload) => onSelectNotification(context, jsonDecode(payload)),
    );
  }

  Future<void> onSelectNotification(BuildContext context, Map payload) async {
    if (payload['platform'] == 'groupme') Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => MessagesPage(payload['name'], payload['sender_id'])),
    );
  }

  Future show({
    NotificationType type,
    @required name,
    @required message,
    String iconUri,
    String payload,
    int id = 0,
    channelID = DM_CHANNEL_ID,
    channelName = DM_CHANNEL_NAME,
    channelDescription = DM_CHANNEL_DESCRIPTION,
  }) async {
    switch (type) {
      case NotificationType.Groupme:
        return showGroupmeNotification(name: name, message: message, iconUri: iconUri, id: id, payload: payload);
      default:
        return null;
    }
  }

  Future showGroupmeNotification({String name, String message, String iconUri, String payload, int id}) async {
    String cachedIconPath = (await DefaultCacheManager().getSingleFile(iconUri)).uri.toFilePath();
    Person person = Person(name: name, icon: BitmapFilePathAndroidIcon(cachedIconPath));

    return localNotificationsPlugin.show(
        id,
        name,
        message,
        NotificationDetails(
          AndroidNotificationDetails(
            DM_CHANNEL_ID,
            DM_CHANNEL_NAME,
            DM_CHANNEL_DESCRIPTION,
            styleInformation: MessagingStyleInformation(
              person,
              conversationTitle: 'GroupMe',
              messages: [Message(message, DateTime.now(), person)],
            ),
          ),
          IOSNotificationDetails(),
        ),
        payload: payload);
  }

  Future<void> cancelAll() => localNotificationsPlugin.cancelAll();
}
