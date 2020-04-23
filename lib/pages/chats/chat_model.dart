class GroupmeChat {
  String threadId;
  String otherUserId;
  String name;
  String avatarUrl;
  String lastMessage;
  int timestamp;

  GroupmeChat({this.threadId, this.otherUserId, this.name, this.timestamp, this.lastMessage, this.avatarUrl});

  // See: https://dev.groupme.com/docs/v3#chats
  factory GroupmeChat.fromJson(Map<String, dynamic> json) {
    return GroupmeChat(
      threadId: json['last_message']['conversation_id'],
      otherUserId: json['other_user']['id'],
      name: json['other_user']['name'],
      avatarUrl: json['other_user']['avatar_url'],
      lastMessage: json['last_message']['text'],
      timestamp: json['updated_at']
    );
  }
}

class GroupmeMessage {
  String id;
  String name;
  String senderId;
  String avatarUrl;
  String text;
  int timestamp;

  // See: https://dev.groupme.com/docs/v3#direct_messages
  GroupmeMessage.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    name = json['name'],
    senderId = json['sender_id'],
    avatarUrl = json['avatar_url'],
    text = json['text'] ?? '',
    timestamp = json['created_at'];
}
