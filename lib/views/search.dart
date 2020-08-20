import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperFunctions.dart';
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

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Conversation()));
    } else {
      print('cant message yourself');
    }
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
      appBar: appBarMain(context),
      body: Container(
        child: Column(children: [
          Container(
            color: Color(0x54FFFFFF),
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Row(children: [
              Expanded(
                child: TextField(
                    controller: search,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: 'Search Username',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none)),
              ),
              GestureDetector(
                onTap: () {
                  initiateSearch();
                },
                child: Container(
                    height: 40,
                    width: 40,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        const Color(0x36FFFFFF),
                        const Color(0x0FFFFFFF)
                      ]),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(Icons.search)),
              )
            ]),
          ),
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
