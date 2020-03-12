import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'package:multacc/common/constants.dart';
import 'package:multacc/pages/chats/chat_model.dart';

part 'chats_data.g.dart';

class ChatsData = _ChatsData with _$ChatsData;

abstract class _ChatsData with Store {
  @observable
  List<GroupmeChat> allChats;

  @observable
  bool loaded = false;

  @action
  getAllChats(String groupmeToken) async {
    loaded = false;
    allChats = await fetchGroupmeChats(groupmeToken);
    loaded = true;
  }

  Future<List<GroupmeChat>> fetchGroupmeChats(String groupmeToken) async {
    http.Client client = http.Client();
    final response = await client.get('$GROUPME_API_URL/chats?token=$groupmeToken');
    return parseChats(response.body);
  }

  List<GroupmeChat> parseChats(String responseBody) {
    final parsed = Map<String, dynamic>.from(jsonDecode(responseBody));
    return parsed['response'].map<GroupmeChat>((json) => GroupmeChat.fromJson(json)).toList();
  }
}
