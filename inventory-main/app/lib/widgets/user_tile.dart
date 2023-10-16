import 'package:flutter/material.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/services/api.dart';

enum UserState { loading, found, notFound }

class UserTile extends StatefulWidget {
  final String identifier;
  final int id;
  final void Function(int id) onDelete;
  final void Function(int id, UserState state, User? user) onStateChange;
  final bool isIdentifierUid;

  const UserTile({
    super.key,
    required this.identifier,
    required this.id,
    required this.onDelete,
    required this.onStateChange,
    this.isIdentifierUid = false,
  });

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  UserState _state = UserState.loading;
  User? user;

  @override
  void initState() {
    _loadUser();
    super.initState();
  }

  Future<void> _loadUser() async {
    setState(() {
      _state = UserState.loading;
    });
    if (widget.isIdentifierUid) {
      user = await APIService.instance.getUser(widget.identifier);
      setState(() {
        _state = UserState.found;
      });
      widget.onStateChange(widget.id, _state, user);
    } else {
      user = await APIService.instance.userExists(widget.identifier);
      if (user == null) {
        setState(() {
          _state = UserState.notFound;
        });
      } else {
        setState(() {
          _state = UserState.found;
        });
      }
      widget.onStateChange(widget.id, _state, user);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case UserState.loading:
        return Card(
          child: ListTile(
            leading: const CircularProgressIndicator(),
            title: const Text("Loading..."),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                widget.onDelete(widget.id);
              },
            ),
          ),
        );
      case UserState.found:
        return Card(
          child: ListTile(
            leading: const Icon(Icons.person),
            title: Text("${user!.fname} ${user!.lname}"),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                widget.onDelete(widget.id);
              },
            ),
          ),
        );
      case UserState.notFound:
        return Card(
          color: Theme.of(context).colorScheme.errorContainer,
          child: ListTile(
            leading: const Icon(Icons.error),
            title: Text(
              "${widget.identifier.length > 18 ? "${widget.identifier.substring(0, 15)}..." : widget.identifier} not found",
            ),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                widget.onDelete(widget.id);
              },
            ),
          ),
        );
    }
  }
}
