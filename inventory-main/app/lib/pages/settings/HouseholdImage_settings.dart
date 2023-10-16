import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/widgets/common/circle_image_picker.dart';

class HouseholdImageSettingsPage extends StatefulWidget {
  final User userData;
  const HouseholdImageSettingsPage({
    super.key,
    required this.userData,
  });
  @override
  State<HouseholdImageSettingsPage> createState() =>
      _HouseholdImageSettingsPageState();
}

class _HouseholdImageSettingsPageState
    extends State<HouseholdImageSettingsPage> {
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
          title: const Text("Household Image Settings"),
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
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    TextField(
                      controller: _firstnameController,
                      decoration: InputDecoration(
                        labelText: "Household name",
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
                    FilledButton(
                      onPressed: () {},
                      child: Row(children: [
                        Expanded(child: Container()),
                        const Text("Done"),
                        Expanded(child: Container())
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
