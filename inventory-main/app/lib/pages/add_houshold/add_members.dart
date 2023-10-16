import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/pages/util/wait.dart';
import 'package:inventory/services/api.dart';
import 'package:inventory/widgets/user_tile.dart';

class AddMembersPage extends StatefulWidget {
  final String householdName;
  final String submitLabel;
  final List<String>? initialUserIds;
  final Uint8List? imageBytes;

  final void Function(List<User> users)? onSubmit;

  const AddMembersPage({
    super.key,
    required this.householdName,
    required this.submitLabel,
    this.onSubmit,
    this.initialUserIds,
    this.imageBytes,
  });

  @override
  State<AddMembersPage> createState() => _AddMembersPageState();
}

class _AddMembersPageState extends State<AddMembersPage> {
  final TextEditingController _emailController = TextEditingController();

  // final List<User?> _users = [];
  // final List<UserTile?> _userTiles = [];
  int _userCount = 0;

  final Map<int, User?> _users = {};
  final Map<int, UserTile> _userTiles = {};

  void updateUser(int id, UserState state, User? user) {
    _users[id] = user;
  }

  void removeUser(int id) {
    _users.remove(id);
    setState(() {
      _userTiles.remove(id);
    });
  }

  void _defaultAction(List<User> users) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WaitScreen(
            future: APIService.instance.createHousehold(
              name: widget.householdName,
              image: widget.imageBytes,
              invitees: users,
            ),
            onSuccess: (_) {
              Navigator.of(context).popUntil(
                (route) => route.isFirst,
              );
            }),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (widget.initialUserIds != null) {
      for (String user in widget.initialUserIds!) {
        _users[_userCount] = null;
        _userTiles[_userCount] = UserTile(
          identifier: user,
          isIdentifierUid: true,
          id: _userCount,
          onDelete: removeUser,
          onStateChange: updateUser,
        );
        _userCount++;
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit members of ${widget.householdName}"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.person_add_alt),
                    onPressed: () {
                      _users[_userCount] = null;
                      setState(() {
                        _userTiles[_userCount] = UserTile(
                          identifier: _emailController.text,
                          id: _userCount,
                          onDelete: removeUser,
                          onStateChange: updateUser,
                        );
                        _emailController.clear();
                        _userCount++;
                      });
                    },
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  children: _userTiles.values.toList(),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 4),
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.onSubmit != null) {
                      widget
                          .onSubmit!(_users.values.whereType<User>().toList());
                    } else {
                      _defaultAction(_users.values.whereType<User>().toList());
                    }
                    // Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.submitLabel),
                      const Icon(Icons.arrow_forward)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
