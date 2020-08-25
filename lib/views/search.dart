import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/conversation.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Database database = new Database();
  TextEditingController search = new TextEditingController();

  QuerySnapshot searchSnapshot;
  initiateSearch() {
    database.getUserByUsername(search.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatRoomConversation({String username}) {
    String chatroomID = getChatRoomId(username, Constants.username);
    if (username != Constants.username) {
      List<String> users = [username, Constants.username];
      Map<String, dynamic> chatroomMap = {
        'users': users,
        'chatroomid': chatroomID
      };
      Database().createChatRoom(
        getChatRoomId(username, Constants.username),
        chatroomMap,
      );

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Conversation(chatroomID)));
    } else {
      print('cant message yourself');
    }
  }

  searchComposer() {
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
              //textCapitalization: TextCapitalization.sentences,
              controller: search,
              decoration:
                  InputDecoration.collapsed(hintText: 'Search for user'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Colors.blue,
            onPressed: () {
              initiateSearch();
            },
          )
        ],
      ),
    );
  }

  Widget searchTile({String username, String useremail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(username, style: mediumtextStyle()),
          Text(useremail, style: mediumtextStyle())
        ]),
        Spacer(),
        GestureDetector(
          onTap: () {
            createChatRoomConversation(username: username);
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              'Message',
              style: mediumtextStyle(),
            ),
          ),
        )
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                username: searchSnapshot.documents[index].data['name'],
                useremail: searchSnapshot.documents[index].data['email'],
              );
            })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: Container(
        padding: EdgeInsets.only(top: 15),
        child: Column(children: [
          searchComposer(),
          searchList(),
        ]),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return '$b\_$a';
  } else {
    return '$a\_$b';
  }
}
