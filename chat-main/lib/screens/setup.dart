import 'package:chat/models/user.dart';
import 'package:chat/services/user_service.dart';
import 'package:chat/widgets/common/circle_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:chat/screens/chat/chat_home.dart';

class SetupPage extends StatefulWidget {
  final String uid;
  const SetupPage({super.key, required this.uid});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();

  Uint8List imageData = Uint8List(0);

  void _updateImage(Uint8List newImage) async {
    imageData = newImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Setup your account"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 30),
        child: Column(
          children: [
            CircleImagePicker(
              onSelect: _updateImage,
              radius: 70,
            ),
            Expanded(
              flex: 3,
              child: Column(children: [
                const SizedBox(height: 40),
                TextField(
                  controller: _firstnameController,
                  decoration: InputDecoration(
                    labelText: "First name",
                    labelStyle: const TextStyle(
                      fontSize: 22,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const Divider(),
                TextField(
                  controller: _lastnameController,
                  decoration: InputDecoration(
                    labelText: "Last name",
                    labelStyle: const TextStyle(
                      fontSize: 22,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ]),
            ),
            FilledButton(
              onPressed: () async {
                //cloud firestore
                final profile = <String, String>{
                  // "user_name": _usernameController.text,
                  "last_name": _lastnameController.text,
                  "first_name": _firstnameController.text,
                };

                String imageUrl =
                    "https://firebasestorage.googleapis.com/v0/b/chat-paradise-gdsc.appspot.com/o/profile_photos%2Fdefault.jpeg?alt=media&token=79142ebf-04d9-4de9-8f51-d2803637f68a";

                if (imageData.isNotEmpty) {
                  Reference imageRefrence = FirebaseStorage.instance.ref(
                    "/profile_photos/${widget.uid}",
                  );
                  await imageRefrence.putData(imageData);
                  imageUrl = await imageRefrence.getDownloadURL();
                }

                await FirebaseFirestore.instance
                    .doc("/users/${widget.uid}")
                    .set(
                  {
                    "first_name": _firstnameController.text,
                    "last_name": _lastnameController.text,
                    "photo_url": imageUrl,
                    "chats": [],
                  },
                );
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatHomeScreen(),
                    ),
                  );
                }
              },
              child: Row(children: [
                Expanded(child: Container()),
                const Text("Done"),
                Expanded(child: Container())
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
