import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:multacc/common/theme.dart';
import 'package:multacc/pages/chats/chat_model.dart';
import 'package:multacc/pages/chats/chats_data.dart';

class MessagesPage extends StatefulWidget {
  final String otherUserName;
  final String otherUserId;

  MessagesPage(this.otherUserName, this.otherUserId);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUserName, style: kHeaderTextStyle.copyWith(fontSize: 22)),
        centerTitle: true,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: _buildMessagesList()),
            _buildComposer(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    return Observer(builder: (context) {
      List<GroupmeMessage> messages = GetIt.I.get<ChatsData>().messages;
      return ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          bool isSelf = messages[index].senderId != widget.otherUserId;
          bool isContinued = index < messages.length - 1 ? messages[index + 1].senderId == messages[index].senderId : false;
          return _buildMessageBubble(messages[index], isSelf: isSelf, isContinued: isContinued);
        },
      );
    });
  }

  Widget _buildMessageBubble(GroupmeMessage message, {@required bool isSelf, bool isContinued = false}) {
    return Bubble(
      child: Text(message.text),
      alignment: isSelf ? Alignment.bottomRight : Alignment.bottomLeft,
      color: isSelf ? kPrimaryColorDark : kBackgroundColorLight,
      padding: BubbleEdges.all(12.0),
      margin: BubbleEdges.fromLTRB(isSelf ? 24.0 : 6.0, isContinued ? 0.0 : 6.0, isSelf ? 6.0 : 24.0, 6.0),
      radius: Radius.circular(18.0),
    );
  }

  Widget _buildComposer() {
    return Container(
      color: kBackgroundColorLight,
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Icon(Icons.image)),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                decoration: InputDecoration.collapsed(hintText: 'Type a message'),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.send,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Icon(Icons.send)),
        ],
      ),
    );
  }
}
