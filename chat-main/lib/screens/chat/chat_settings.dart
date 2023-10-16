import 'dart:typed_data';

import 'package:chat/models/chat.dart';
import 'package:chat/widgets/common/circle_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatSettings extends StatefulWidget {
  final Chat? chat;
  final String? chatId;
  final String? heroTag;
  const ChatSettings({super.key, this.chat, this.chatId, this.heroTag});

  @override
  State<ChatSettings> createState() => _ChatSettingsState();
}

class _ChatSettingsState extends State<ChatSettings> {
  bool masterEnable = true;
  bool previewEnable = true;
  bool groupchatEnable = true;
  bool vibrationEnable = true;

  final TextEditingController _nameController = TextEditingController();

  void _updateImage(Uint8List newImage) async {
    Reference imageRefrence = FirebaseStorage.instance.ref(
      "/chat_icons/${widget.chatId}",
    );
    await imageRefrence.putData(newImage);
    await FirebaseFirestore.instance.doc("chats/${widget.chatId}").update(
      {"display_photo": await imageRefrence.getDownloadURL()},
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.chat != null) {
      setState(() {
        _nameController.text = widget.chat!.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat Settings")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.chat != null
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: widget.heroTag!,
                        child: CircleImagePicker(
                          onSelect: _updateImage,
                          initialImage: NetworkImage(widget.chat!.photo),
                          radius: 50,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 8,
                        child: TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: "Chat name",
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
            const Divider(),
            ListTile(
              title: const Text("All Notification"),
              trailing: Switch(
                value: masterEnable,
                onChanged: (value) {
                  setState(() {
                    masterEnable = value;
                  });
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text("Group-Chat Notification"),
              trailing: Switch(
                value: groupchatEnable,
                onChanged: (value) {
                  setState(() {
                    groupchatEnable = value;
                  });
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text("Show Previews"),
              trailing: Switch(
                value: previewEnable,
                onChanged: (value) {
                  setState(() {
                    previewEnable = value;
                  });
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text("Delete All Chat"),
              onTap: () {
                showAlertDialog(context);
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("Delete"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Delete All Chat"),
    content: Text("Would you like to delete all chat history?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
