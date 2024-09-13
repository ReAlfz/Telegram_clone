import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String text, fromUid, uid;
  final bool sender;
  final Timestamp timestamp;

  const ChatModel({
    required this.uid,
    required this.fromUid,
    required this.sender,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fromUid': fromUid,
      'sender': sender,
      'text': text,
      'timestamp': timestamp
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      uid: map['uid'],
      text: map['text'],
      fromUid: map['fromUid'],
      sender: map['sender'],
      timestamp: map['timestamp'],
    );
  }
}