import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/pages/util/wait.dart';
import 'package:inventory/services/api.dart';
import 'package:inventory/widgets/common/circle_image_picker.dart';

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
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();

  Uint8List? _image;

  @override
  void initState() {
    setState(() {
      _firstnameController.text = widget.userData.fname;
      _lastnameController.text = widget.userData.lname;
    });
    super.initState();
  }

  void _updateImage(Uint8List newImage) async {
    _image = newImage;
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
                widget.userData.photoURL,
              ),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WaitScreen<void>(
                      future: APIService.instance.updateUser(
                        initialData: widget.userData,
                        fname:
                            _firstnameController.text == widget.userData.fname
                                ? null
                                : _firstnameController.text,
                        lname: _lastnameController.text == widget.userData.lname
                            ? null
                            : _lastnameController.text,
                        photo: _image,
                      ),
                      onSuccess: (_) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
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
