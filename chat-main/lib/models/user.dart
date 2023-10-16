import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class User {
  String? uuid;
  String? firstName;
  String? lastName;
  String? profilePhoto;
  List<String> chats;

  User({
    this.firstName,
    this.lastName,
    this.profilePhoto,
    this.uuid,
    this.chats = const [],
  });

  static Future<User?> fromReference(String uid) async {
    var doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    if (doc.exists) {
      var data = doc.data()!;
      return User(
        firstName: data["first_name"],
        lastName: data["last_name"],
        profilePhoto: data["photo_url"],
        chats:
            (data["chats"] as List<dynamic>).map((e) => e as String).toList(),
        uuid: uid,
      );
    }
    return null;
  }

  Map<String, dynamic> toSenderMap() => {
        "first_name": firstName,
        "last_name": lastName,
        "photo_url": profilePhoto,
      };
}
