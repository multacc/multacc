import 'dart:convert';

import 'package:flutter_foreground_plugin/flutter_foreground_plugin.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

import 'package:multacc/common/constants.dart';
import 'package:multacc/common/notifications.dart';

class Foreground {
  Foreground._();
  static final Foreground instance = Foreground._();

  /// Starts foreground service if not already running
  void startForegroundService({Function onStarted}) async {
    await FlutterForegroundPlugin.setServiceMethodInterval(seconds: 86400);
    await FlutterForegroundPlugin.setServiceMethod(periodicForegroundTask);
    await FlutterForegroundPlugin.startForegroundService(
      holdWakeLock: false,
      onStarted: onStarted ?? listenForMessages,
      onStopped: () => print('Foreground service stopped'),
      title: 'Notification service',
      content: 'Multacc is running in the background.',
      iconName: 'ic_stat_multacc',
    );
  }

  void stopForegroundService() async {
    await FlutterForegroundPlugin.stopForegroundService();
  }

  /// Listens to groupme message events and creates push notifications
  // see https://dev.groupme.com/tutorials/push
  void listenForMessages() async {
    SharedPreferences prefs = GetIt.I.get<SharedPreferences>();

    String groupmeToken = prefs.getString('GROUPME_TOKEN');
    if (groupmeToken != null) {
      String groupmeUserid = prefs.getString('GROUPME_ID');

      String groupmeClientId = await performGroupmeHandshake();
      await subscribeToGroupme(groupmeClientId, groupmeToken, groupmeUserid);

      // open a websocket connection to groupme
      IOWebSocketChannel groupmeConnection = IOWebSocketChannel.connect(GROUPME_WEBSOCKET_HOST);
      groupmeConnection.sink.add(
        jsonEncode({"channel": "/meta/connect", "clientId": groupmeClientId, "connectionType": "websocket", "id": "3"}),
      );

      // show notification when a DM arrives
      groupmeConnection.stream.listen((e) {
        try {
          var data = jsonDecode(e)[0]['data'];
          var message = data['subject'];
          if (data['type'] == 'direct_message.create' && message['sender_id'] != groupmeUserid) {
            Notifications.instance.show(
              type: NotificationType.Groupme,
              name: message['name'],
              message: message['text'],
              iconUri: message['avatar_url'],
              payload: jsonEncode({
                'name': message['name'],
                'sender_id': message['sender_id'],
                'platform': 'groupme',
              }),
            );
          }
        } catch (ex) {
          print(ex);
        }
      });
    }
  }

  /// Returns a client id after a handshake with the groupme push API
  Future<String> performGroupmeHandshake() async {
    http.Response response = await http.Client().post(
      GROUPME_PUSH_URL,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode([
        {
          "channel": "/meta/handshake",
          "version": "1.0",
          "supportedConnectionTypes": ["websocket"],
          "id": "1"
        }
      ]),
    );
    return jsonDecode(response.body)[0]['clientId'];
  }

  /// Subscribes to all groupme message events for the current user
  Future subscribeToGroupme(String clientId, String accessToken, String userId) async {
    return http.Client().post(
      GROUPME_PUSH_URL,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "channel": "/meta/subscribe",
        "clientId": clientId,
        "subscription": "/user/$userId",
        "id": "2",
        "ext": {"access_token": accessToken}
      }),
    );
  }
}

/// Top level method to be run periodically by the foreground service
// We don't really care about this because we use the onStarted function instead
periodicForegroundTask() => print('periodic method: ${DateTime.now()}');
