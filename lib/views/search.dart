import 'package:chatapp/services/database.dart';
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

  // createChatRoomConversation(String username) {
  //   List<String> users = [username, myName];
  //   database.createChatRoom();
  // }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                username: searchSnapshot.documents[index].data['name'],
                useremail: searchSnapshot.documents[index].data['email'],
              );
            })
        : Container();
  }

  @override
  void initState() {
    super.initState();
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

class SearchTile extends StatelessWidget {
  final String username;
  final String useremail;

  SearchTile({this.username, this.useremail});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(username, style: mediumtextStyle()),
          Text(useremail, style: mediumtextStyle())
        ]),
        Spacer(),
        GestureDetector(
          onTap: () {},
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
}
