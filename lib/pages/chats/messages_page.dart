import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
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
          GroupmeMessage message = messages[index];
          bool isSelf = message.senderId != widget.otherUserId;
          bool isContinued = index < messages.length - 1 ? messages[index + 1].senderId == message.senderId : false;
          return GroupmeBubble(message: messages[index], isSelf: isSelf, isContinued: isContinued);
        },
      );
    });
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

class GroupmeBubble extends StatefulWidget {
  const GroupmeBubble({
    Key key,
    @required this.message,
    @required this.isSelf,
    @required this.isContinued,
  }) : super(key: key);

  final GroupmeMessage message;
  final bool isSelf;
  final bool isContinued;

  @override
  _GroupmeBubbleState createState() => _GroupmeBubbleState();
}

class _GroupmeBubbleState extends State<GroupmeBubble> {
  bool showTimestamp = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => showTimestamp = !showTimestamp),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(widget.isSelf ? 18.0 : 6.0, 0.0, widget.isSelf ? 6.0 : 18.0, 6.0),
        child: Column(
          children: <Widget>[
            Bubble(
              child: Text(widget.message.text),
              alignment: widget.isSelf ? Alignment.bottomRight : Alignment.bottomLeft,
              color: widget.isSelf ? kPrimaryColorDark : kBackgroundColorLight,
              padding: BubbleEdges.all(15.0),
              margin: BubbleEdges.only(top: widget.isContinued ? 0.0 : 6.0),
              radius: Radius.circular(24.0),
            ),
            if (showTimestamp) _showTimestamp(),
          ],
        ),
      ),
    );
  }

  Widget _showTimestamp() {
    DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(widget.message.timestamp * 1000);
    bool isToday = timestamp.day == DateTime.now().day && timestamp.month == DateTime.now().month;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        DateFormat(isToday ? 'HH:mm' : 'MMM dd, HH:mm').format(timestamp),
        style: kTinyTextStyle.copyWith(color: Colors.grey),
        textAlign: widget.isSelf ? TextAlign.right : TextAlign.left,
      ),
    );
  }

  
}

