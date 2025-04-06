import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String receiverID;
  final String senderEmail;
  final String message;
  final Timestamp timestamp;
  final String name;

  Message(
      {required this.senderID,
      required this.receiverID,
      required this.senderEmail,
      required this.message,
      required this.timestamp,
      required this.name});

  //convert to a map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderID,
      'senderEmail': senderEmail,
      'message': message,
      'timestamp': timestamp,
      'receiverId': receiverID,
      'name': name,
    };
  }
}
