class Message {
  final String senderName;
  final String senderId;
  final String text;
  final DateTime timestamp;

  Message(
      {required this.senderName,
      required this.senderId,
      required this.text,
      required this.timestamp});
}
