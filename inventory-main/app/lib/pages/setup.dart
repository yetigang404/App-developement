import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/pages/home/home.dart';
import 'package:inventory/pages/util/wait.dart';
import 'package:inventory/services/api.dart';
import 'package:inventory/services/user.dart';
import 'package:inventory/widgets/common/circle_image_picker.dart';

class SetupScreen extends StatefulWidget {
  final String uid;
  final String email;
  const SetupScreen({super.key, required this.uid, required this.email});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
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
                String imageUrl =
                    "https://firebasestorage.googleapis.com/v0/b/chat-paradise-gdsc.appspot.com/o/profile_photos%2Fdefault.jpeg?alt=media&token=79142ebf-04d9-4de9-8f51-d2803637f68a";

                if (imageData.isNotEmpty) {
                  Reference imageRefrence = FirebaseStorage.instance.ref(
                    "/profile_photos/${widget.uid}",
                  );
                  await imageRefrence.putData(imageData);
                  imageUrl = await imageRefrence.getDownloadURL();
                }

                final User user = User(
                  uid: widget.uid,
                  fname: _firstnameController.text,
                  lname: _lastnameController.text,
                  email: widget.email,
                  photoURL: imageUrl,
                  households: [],
                  inventory: "__PLACEHOLDER__REPLACE",
                  invitations: [],
                );

                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WaitScreen<void>(
                        future: APIService.instance.createUser(user),
                        onSuccess: (_) async {
                          await UserService.instance.refresh();
                          if (context.mounted) {
                            Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          }
                        },
                      ),
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
