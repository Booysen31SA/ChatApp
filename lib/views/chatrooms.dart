import 'package:chatapp/helper/authenicate.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperFunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/conversation.dart';
import 'package:chatapp/views/search.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  AuthMethods authMethods = new AuthMethods();
  Database database = new Database();
  Stream chatroomStream;

  Widget chatroomList() {
    return StreamBuilder(
        stream: chatroomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return ChatroomTile(
                        snapshot.data.documents[index].data['chatroomid']
                            .toString()
                            .replaceAll('_', '')
                            .replaceAll(Constants.username, ''),
                        snapshot.data.documents[index].data['chatroomid']);
                  },
                )
              : Container();
        });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.username = await HelperFunctions.getUserNameSharedPreference();
    database.getChatrooms(Constants.username).then((val) {
      setState(() {
        chatroomStream = val;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chats'), actions: [
        GestureDetector(
          onTap: () {
            authMethods.signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Authenticate()));
          },
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app)),
        )
      ]),
      body: chatroomList(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Search()));
          }),
    );
  }
}

class ChatroomTile extends StatelessWidget {
  final String username;
  final String chatroomid;
  ChatroomTile(this.username, this.chatroomid);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Conversation(chatroomid)));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(40)),
              child: Text(
                '${username.substring(0, 1).toUpperCase()}',
                style: mediumtextStyle(),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              username,
              style: mediumtextStyle(),
            )
          ],
        ),
      ),
    );
  }
}
