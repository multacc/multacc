import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:multacc/common/theme.dart';
import 'package:multacc/main.dart';
import 'package:multacc/pages/chats/chats_data.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  ChatsData chatsData;

  @override
  void initState() {
    super.initState();
    chatsData = services.get<ChatsData>();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => !chatsData.loaded ? Center(child: CircularProgressIndicator()) : _buildChatsList(),
    );
  }

  Widget _buildChatsList() {
    return Observer(
      builder: (_) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(itemCount: chatsData.allChats.length, itemBuilder: (_, index) => _buildChatTile(index)),
      ),
    );
  }

  Widget _buildChatTile(int index) {
    var chat = chatsData.allChats[index];
    return ListTile(
      leading: _buildAvatar(chat.avatarUrl),
      title: Text(chat.name),
      subtitle: Text(chat.lastMessage, overflow: TextOverflow.ellipsis),
      trailing: _buildTimestamp(chat.timestamp),
      // onTap: () => showDraggableSheet(context, Center(child: Text('DM'))), // @todo Implement conversation screen
    );
  }

  Text _buildTimestamp(int timestamp) {
    var moment = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    String pattern = 'H:mm';

    int daysSince = DateTime.now().difference(moment).inDays;
    if (daysSince > 1 && daysSince < 6) {
      pattern = 'E, H:mm';
    } else {
      pattern = 'MMMd';
    }

    return Text(DateFormat(pattern).format(moment), style: kTinyTextStyle);
  }

  Widget _buildAvatar(String url) {
    if (url == null) return CircleAvatar(child: Icon(Icons.person), backgroundColor: kBackgroundColorLight);
    return CircleAvatar(backgroundImage: NetworkImage(url));
  }
}
