class Message {
  final String message;
  final String senderUsername;
  final DateTime sentAt;
  final String groupid;
  final String receiver;

  Message(
      {required this.message,
      required this.senderUsername,
      required this.sentAt,
      required this.groupid,
      required this.receiver});

  factory Message.fromJson(Map<String, dynamic> message) {
    return Message(
        message: message['message'],
        senderUsername: message['senderUsername'],
        receiver: message['receiver'],
        sentAt: DateTime.fromMillisecondsSinceEpoch(message['sentAt']),
        groupid: message['groupid']);
  }
}
