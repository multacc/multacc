import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart';

import 'package:multacc/common/constants.dart';
import 'package:multacc/pages/chats/chat_model.dart';

part 'chats_data.g.dart';

class ChatsData = _ChatsData with _$ChatsData;

abstract class _ChatsData with Store {
  http.Client _httpClient;
  String _groupmeToken;
  List<dynamic> inbox = [];
  Set<dynamic> chats = new Set();
  List<List<dynamic>> smsMessages = [];

  static const platform = const MethodChannel('com.multacc/sms-handler');

  _ChatsData() {
    _httpClient = http.Client();
  }

  @observable
  List<GroupmeChat> allChats = [];

  @observable
  List<GroupmeMessage> messages = []; // messages for the currently open thread

  void updateGroupmeToken({String token}) {
    _groupmeToken =
        token ?? GetIt.I.get<SharedPreferences>().getString('GROUPME_TOKEN');
  }

  @action
  getAllChats({String groupmeToken}) async {
    updateGroupmeToken(token: groupmeToken);
    http.Response response =
        await _httpClient.get('$GROUPME_API_URL/chats?token=$_groupmeToken');
    allChats = jsonDecode(response.body)['response']
        .map<GroupmeChat>((json) => GroupmeChat.fromJson(json))
        .toList();
  }

  @action
  getMessages(String otherUserId) async {
    http.Response response = await _httpClient.get(
        '$GROUPME_API_URL/direct_messages?other_user_id=$otherUserId&token=$_groupmeToken');
    messages = jsonDecode(response.body)['response']['direct_messages']
        .map<GroupmeMessage>((json) => GroupmeMessage.fromJson(json))
        .toList();
  }

  Future<void> refreshChats() async {
    inbox = [];
    chats = new Set();
    smsMessages = [];
    await _initializeSmsMessages();
  }

  Future<void> _initializeSmsMessages() async {
    if (chats.isEmpty) await _initializeChats();

    for (var i = 0; i < chats.length; i++) {
      String num = chats.elementAt(i);
      for (var j = 0; j < inbox.length; j++) {
        String msg = inbox[j];
        if(msg.contains(num))
          smsMessages[i].add(msg);
      }
    }
  }

  Future<void> _initializeInbox() async {
    try {
      inbox = await platform.invokeMethod('readTexts');
    } catch (e) {
      print(e);
    }

    print("dumb\n\n");
    print(inbox[0]);
  }

  void _initializeChats() async {
    if (inbox == []) await _initializeInbox();
    if (chats.isNotEmpty) return;
    for (var i = 0; i < inbox.length; i++) {
      String msg = inbox[i] as String;
      String num = getNumber(msg);
      chats.add(num);
    }
  }

  String getNumber(String msg){
    int index = msg.indexOf("address");
    String num = msg.substring(index + 8, index + 8 + 10);
    return num;
  }

  //returns true if the message was received, false if the message was sent
  bool isRecievedMessage(String msg){
    int index = msg.indexOf("type");
    String type = msg.substring(index + 5, index + 5 + 1);
    return (type == "1");
  }

  List<dynamic> getInbox() {
    if (inbox == []) {
      _initializeInbox();
    }
    return inbox;
  }

  List<List<dynamic>> getSmsMessages() {
    if (smsMessages == []) {
      _initializeSmsMessages();
    }
    return smsMessages;
  }

  Set<dynamic> getChats() {
    if (chats.isEmpty) {
      _initializeChats();
    }
    return chats;
  }

  //just for debugging
  void printChats() async {
    await _initializeSmsMessages();
    print("\n\nINBOX:\n\n");
    for (var i = 0; i < inbox.length; i++) {
      print(inbox[i] as String);
      print("\n");
    }
    print("\n\nCHATS:\n\n");
    for (var i = 0; i < chats.length; i++) {
      print(chats.elementAt(i));
      print("\n");
    }
    print("\n\nMESSAGES:\n\n");
    for (var i = 0; i < smsMessages.length; i++) {
      print(smsMessages.elementAt(i));
      print("\n");
    }
  }
}
