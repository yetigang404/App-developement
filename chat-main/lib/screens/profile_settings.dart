import 'dart:typed_data';

import 'package:chat/models/user.dart';
import 'package:chat/screens/chat/chat_home.dart';
import 'package:chat/services/user_service.dart';
import 'package:chat/widgets/common/circle_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileSettingsPage extends StatefulWidget {
  final User userData;
  const ProfileSettingsPage({
    super.key,
    required this.userData,
  });

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();

  @override
  void initState() {
    setState(() {
      _firstnameController.text = widget.userData.firstName!;
      _lastnameController.text = widget.userData.lastName!;
    });
    super.initState();
  }

  void _updateImage(Uint8List newImage) async {
    Reference imageRefrence = FirebaseStorage.instance.ref(
      "/profile_photos/${widget.userData.uuid}",
    );
    await imageRefrence.putData(newImage);
    UserService.getInstance().updateUser(
      User(
        profilePhoto: await imageRefrence.getDownloadURL(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Profile Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 30),
        child: Column(
          children: [
            CircleImagePicker(
              onSelect: _updateImage,
              radius: 70,
              initialImage: NetworkImage(
                UserService.getInstance().getCurrentUser()!.profilePhoto!,
              ),
            ),
            // Expanded(
            //   flex: 1,
            //   child: Container(),
            // ),
            Expanded(
              flex: 3,
              child: Column(children: [
                const SizedBox(height: 40),
                // TextField(
                //   controller: _usernameController,
                //   decoration: InputDecoration(
                //     labelText: "User name",
                //     labelStyle: TextStyle(
                //       fontSize: 22,
                //     ),
                //     border: OutlineInputBorder(
                //       borderSide: BorderSide(
                //         color: Theme.of(context).colorScheme.secondary,
                //       ),
                //     ),
                //   ),
                //   keyboardType: TextInputType.emailAddress,
                // ),
                // Divider(),
                TextField(
                  controller: _firstnameController,
                  decoration: InputDecoration(
                    labelText: "First name",
                    labelStyle: TextStyle(
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
                Divider(),
                TextField(
                  controller: _lastnameController,
                  decoration: InputDecoration(
                    labelText: "Last name",
                    labelStyle: TextStyle(
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
              onPressed: () {
                //cloud firestore
                final profile = <String, String>{
                  // "user_name": _usernameController.text,
                  "last_name": _lastnameController.text,
                  "first_name": _firstnameController.text,
                };

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChatHomeScreen()));
              },
              child: Row(children: [
                Expanded(child: Container()),
                Text("Done"),
                Expanded(child: Container())
              ]),
              // style: ButtonStyle(
              //   padding:
              //       MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
              //   foregroundColor: MaterialStateProperty.all<Color>(
              //       Theme.of(context).colorScheme.secondary),
              //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //     RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10.0),
              //       side: BorderSide(
              //         color: Theme.of(context).colorScheme.secondary,
              //       ),
              //     ),
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
