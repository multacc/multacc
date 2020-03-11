class GroupmeChat {
  String threadId;
  String userId;
  String name;
  String avatarUrl;
  String lastMessage;
  int timestamp;

  GroupmeChat({this.threadId, this.userId, this.name, this.timestamp, this.lastMessage, this.avatarUrl});

  // See: https://dev.groupme.com/docs/v3#chats
  factory GroupmeChat.fromJson(Map<String, dynamic> json) {
    return GroupmeChat(
      threadId: json['last_message']['conversation_id'],
      userId: json['other_user']['id'],
      name: json['other_user']['name'],
      avatarUrl: json['other_user']['avatar_url'],
      lastMessage: json['last_message']['text'],
      timestamp: json['updated_at']
    );
  }
}
