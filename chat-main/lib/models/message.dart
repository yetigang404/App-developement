import 'package:chat/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum MessageType { text, image }

class Message {
  final MessageType messageType;
  final String contents;
  final User sender;
  final Timestamp timestamp;

  const Message(
      {required this.messageType,
      required this.contents,
      required this.sender,
      required this.timestamp});

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      messageType: map["type"] == "text" ? MessageType.text : MessageType.image,
      contents: map["contents"],
      timestamp: map["timestamp"],
      sender: User(
        firstName: map["sender"]["first_name"],
        lastName: map["sender"]["last_name"],
        profilePhoto: map["sender"]["photo_url"],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "contents": contents,
        "type": describeEnum(messageType),
        "sender": sender.toSenderMap(),
        "timestamp": timestamp,
      };
}
