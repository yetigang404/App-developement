import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inventory/pages/add_houshold/add_members.dart';
import 'package:inventory/widgets/common/circle_image_picker.dart';

class AddHouseholdPage extends StatefulWidget {
  const AddHouseholdPage({super.key});

  @override
  State<AddHouseholdPage> createState() => _AddHouseholdPageState();
}

class _AddHouseholdPageState extends State<AddHouseholdPage> {
  final TextEditingController _nameController = TextEditingController();
  Uint8List? _imageBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Household'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  CircleImagePicker(
                    onSelect: (data) => {_imageBytes = data},
                    radius: 68,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.streetAddress,
                    decoration: const InputDecoration(
                      labelText: 'Household Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMembersPage(
                      householdName: _nameController.text,
                      imageBytes: _imageBytes,
                      submitLabel: "Create Household & Invite Members",
                    ),
                  ),
                );
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Add Members'),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
