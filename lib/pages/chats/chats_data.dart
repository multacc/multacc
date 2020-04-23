import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:multacc/common/constants.dart';
import 'package:multacc/pages/chats/chat_model.dart';
import 'package:uuid/uuid.dart';

part 'chats_data.g.dart';

class ChatsData = _ChatsData with _$ChatsData;

abstract class _ChatsData with Store {
  http.Client _httpClient;
  String _groupmeToken;
  final uuid = Uuid();

  _ChatsData() {
    _httpClient = http.Client();
  }

  @observable
  List<GroupmeChat> allChats = [];
  
  @observable
  /// Direct messages for the currently open thread
  ObservableList<GroupmeMessage> messages = ObservableList<GroupmeMessage>();

  void updateGroupmeToken({String token}) {
    _groupmeToken = token ?? GetIt.I.get<SharedPreferences>().getString('GROUPME_TOKEN');
  }

  @action
  /// Fetches a list of GroupMe DM threads
  Future<List<GroupmeChat>> getAllChats({String groupmeToken}) async {
    updateGroupmeToken(token: groupmeToken);
    http.Response response = await _httpClient.get('$GROUPME_API_URL/chats?token=$_groupmeToken');
    return allChats = jsonDecode(response.body)['response'].map<GroupmeChat>((json) => GroupmeChat.fromJson(json)).toList();
  }

  @action
  /// Fetches GroupmeMe DMs for a particular conversation thread (most recent 20)
  Future<List<GroupmeMessage>> getMessages(String otherUserId) async {
    http.Response response = await _httpClient.get('$GROUPME_API_URL/direct_messages?other_user_id=$otherUserId&token=$_groupmeToken');
    messages.clear();
    messages.addAll(jsonDecode(response.body)['response']['direct_messages'].map<GroupmeMessage>((json) => GroupmeMessage.fromJson(json)).toList());
    return messages;
  }

  @action
  /// Fetches the "next" 20 GroupMe DMs in a thread (used when scrolling up). Returns false if unable to load more messages
  Future<bool> getMoreMessages(String otherUserId) async {
    http.Response response = await _httpClient.get('$GROUPME_API_URL/direct_messages?other_user_id=$otherUserId&token=$_groupmeToken&before_id=${messages.last.id}');
    List<GroupmeMessage> olderMessages = jsonDecode(response.body)['response']['direct_messages'].map<GroupmeMessage>((json) => GroupmeMessage.fromJson(json)).toList();
    if (olderMessages.isEmpty) return false;
    messages.addAll(olderMessages);
    return true;
  }
  
  @action
  /// Sends a GroupMe DM (text) and updates list of messages
  sendMessage(String otherUserId, String text) async {
    Map message = {
      'direct_message': {
        'source_guid': uuid.v4(),
        'recipient_id': otherUserId,
        'text': text,
      }
    };
    http.Response response = await _httpClient.post('$GROUPME_API_URL/direct_messages?token=$_groupmeToken',
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(message),
    );
    return getMessages(otherUserId);
  }
}
