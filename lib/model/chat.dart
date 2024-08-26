class ChatModel {
  final String text, fromUid, uid;
  final int timestamp;

  const ChatModel({
    required this.uid,
    required this.fromUid,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fromUid': fromUid,
      'text': text,
      'timestamp': timestamp
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      uid: map['uid'] ?? '',
      text: map['text'] ?? '',
      fromUid: map['fromUid']?? '',
      timestamp: map['timestamp']?? 0,
    );
  }
}