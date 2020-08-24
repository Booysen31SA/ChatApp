import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  final String chatroomid;
  Conversation(this.chatroomid);
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  Database database = new Database();
  String chat;
  TextEditingController send = new TextEditingController();

  Stream chatMessages;

  Widget chatmessageList() {
    return StreamBuilder(
        stream: chatMessages,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.only(top: 15.0),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        snapshot.data.documents[index].data['message'],
                        snapshot.data.documents[index].data['sendby'] ==
                            Constants.username);
                  })
              : Container();
        });
  }

  buildMessageComposer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 60.0,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: send,
              decoration: InputDecoration.collapsed(hintText: 'Send Message'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Colors.blue,
            onPressed: () {
              sendMessage();
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    database.getConversation(widget.chatroomid).then((val) {
      setState(() {
        chatMessages = val;
      });
    });
    super.initState();
  }

  sendMessage() {
    if (send.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': send.text,
        'sendby': Constants.username,
        'time': DateTime.now().millisecondsSinceEpoch
      };

      database.addConversation(
        widget.chatroomid,
        messageMap,
      );
      send.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.chatroomid
              .replaceAll('_', '')
              .replaceAll(Constants.username, ''),
        ),
      ),
      body: Container(
          child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 60),
            child: chatmessageList(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: buildMessageComposer(),
          ),
        ],
      )),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final isSendByMe;
  MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 24, right: isSendByMe ? 16 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSendByMe
                  ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                  : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
            ),
            borderRadius: isSendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23))),
        child: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}
