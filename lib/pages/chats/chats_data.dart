import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:multacc/common/constants.dart';
import 'package:multacc/pages/chats/chat_model.dart';

part 'chats_data.g.dart';

class ChatsData = _ChatsData with _$ChatsData;

abstract class _ChatsData with Store {
  http.Client _httpClient;
  String _groupmeToken;

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
  getAllChats({String groupmeToken}) async {
    updateGroupmeToken(token: groupmeToken);
    http.Response response = await _httpClient.get('$GROUPME_API_URL/chats?token=$_groupmeToken');
    allChats = jsonDecode(response.body)['response'].map<GroupmeChat>((json) => GroupmeChat.fromJson(json)).toList();
  }

  @action
  getMessages(String otherUserId) async {
    http.Response response = await _httpClient.get('$GROUPME_API_URL/direct_messages?other_user_id=$otherUserId&token=$_groupmeToken');
    messages = jsonDecode(response.body)['response']['direct_messages'].map<GroupmeMessage>((json) => GroupmeMessage.fromJson(json)).toList();
  }
}
