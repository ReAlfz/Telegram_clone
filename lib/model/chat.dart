class ChatModel {
  final String uid, username, toText, fromText, icon;

  const ChatModel({
    required this.username,
    required this.fromText,
    required this.toText,
    required this.icon,
    required this.uid,
  });
}