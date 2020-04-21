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
  List<GroupmeMessage> messages = []; // messages for the currently open thread

  void updateGroupmeToken({String token}) {
    _groupmeToken = token ?? GetIt.I.get<SharedPreferences>().getString('GROUPME_TOKEN');
  }

  @action
  Future<List<GroupmeChat>> getAllChats({String groupmeToken}) async {
    updateGroupmeToken(token: groupmeToken);
    http.Response response = await _httpClient.get('$GROUPME_API_URL/chats?token=$_groupmeToken');
    return allChats = jsonDecode(response.body)['response'].map<GroupmeChat>((json) => GroupmeChat.fromJson(json)).toList();
  }

  @action
  Future<List<GroupmeMessage>> getMessages(String otherUserId) async {
    http.Response response = await _httpClient.get('$GROUPME_API_URL/direct_messages?other_user_id=$otherUserId&token=$_groupmeToken');
    return messages = jsonDecode(response.body)['response']['direct_messages'].map<GroupmeMessage>((json) => GroupmeMessage.fromJson(json)).toList();
  }
  
  @action
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
