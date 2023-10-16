import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  static Future<String> uploadImage({
    required Uint8List imageData,
    required String folder,
    required String? id,
  }) async {
    String imageUrl =
        "https://firebasestorage.googleapis.com/v0/b/chat-paradise-gdsc.appspot.com/o/profile_photos%2Fdefault.jpeg?alt=media&token=79142ebf-04d9-4de9-8f51-d2803637f68a";

    if (imageData.isNotEmpty) {
      id ??= UniqueKey().toString();
      Reference imageRefrence = FirebaseStorage.instance.ref(
        "/$folder/$id",
      );
      await imageRefrence.putData(imageData);
      imageUrl = await imageRefrence.getDownloadURL();
    }

    return imageUrl;
  }
}
