import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:multacc/common/constants.dart';

class Notifications {
  Notifications._();
  static final Notifications instance = Notifications._();

  FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<bool> init() async {
    return localNotificationsPlugin.initialize(
      InitializationSettings(
        AndroidInitializationSettings('ic_stat_multacc'),
        IOSInitializationSettings(),
      ),
    );
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    // await Navigator.push(context, pageRoute);
  }

  Future show({
    @required title,
    @required message,
    int id = 0,
    channelID = DM_CHANNEL_ID,
    channelName = DM_CHANNEL_NAME,
    channelDescription = DM_CHANNEL_DESCRIPTION,
  }) async {
    return localNotificationsPlugin.show(
      id,
      title,
      message,
      NotificationDetails(
        AndroidNotificationDetails(channelID, channelName, channelDescription),
        IOSNotificationDetails(),
      ),
    );
  }

  Future<void> cancelAll() => localNotificationsPlugin.cancelAll();
}
