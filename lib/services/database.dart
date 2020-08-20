import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection('users')
        .where('name', isEqualTo: username)
        .getDocuments();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection('users').add(userMap);
  }

  createChatRoom(String chatroomid, chatroomMap) {
    Firestore.instance.collection('Chatroom').document(chatroomid).setData(chatroomMap);
  }
}
