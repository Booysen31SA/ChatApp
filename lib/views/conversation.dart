import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';

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
                            Constants.username,
                        readTimestamp(
                            snapshot.data.documents[index].data['time']));
                  })
              : Container();
        });
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('dd MMMM yy HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
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
    if (send.text.isNotEmpty || send.text.length > 0) {
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
    } else {
      Toast.show('Please type a message', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
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
  final time;
  MessageTile(this.message, this.isSendByMe, this.time);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
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
      ),
      Container(
        padding: EdgeInsets.only(
            left: isSendByMe ? 0 : 24, right: isSendByMe ? 16 : 0),
        child: Row(
          mainAxisAlignment:
              isSendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    ]);
  }
}
