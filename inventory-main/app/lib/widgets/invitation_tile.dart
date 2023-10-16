import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:inventory/models/household.dart';

import 'package:inventory/models/invitation.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/services/api.dart';

enum _TaskState {
  idle,
  loading,
  accepting,
  declining,
}

class InvitationTile extends StatefulWidget {
  final Invitation invitaion;
  final String inventoryId;
  final int idx;
  final void Function(int idx) onAction;
  const InvitationTile({
    super.key,
    required this.idx,
    required this.invitaion,
    required this.inventoryId,
    required this.onAction,
  });

  @override
  State<InvitationTile> createState() => _InvitationTileState();
}

class _InvitationTileState extends State<InvitationTile> {
  User? _invitee;
  Household? _household;
  _TaskState _taskState = _TaskState.loading;

  void _load() async {
    final invitee = await APIService.instance.getUser(widget.invitaion.sender);
    final household = (await APIService.instance.getHouseholds(
      [widget.invitaion.household],
    ))[0];
    setState(() {
      _invitee = invitee;
      _household = household;
      _taskState = _TaskState.idle;
    });
  }

  void _accept() async {
    setState(() {
      _taskState = _TaskState.accepting;
    });
    await APIService.instance.acceptInvitation(
      widget.invitaion,
      widget.inventoryId,
    );
    widget.onAction(widget.idx);
  }

  void _decline() async {
    setState(() {
      _taskState = _TaskState.declining;
    });
    await APIService.instance.declineInvitation(
      widget.invitaion,
      widget.inventoryId,
    );
    widget.onAction(widget.idx);
  }

  @override
  Widget build(BuildContext context) {
    if (_invitee != null && _household != null) {
      return ListTile(
        title: Text(_household!.name),
        subtitle: Text(
          "${_invitee!.fname} ${_invitee!.lname} "
          "invited you to join ${_household!.name}",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: _taskState == _TaskState.idle ? _accept : null,
              icon: _taskState == _TaskState.accepting
                  ? CircularProgressIndicator(
                      color: Colors.green.harmonizeWith(
                        Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : Icon(
                      Icons.check,
                      color: _taskState == _TaskState.idle
                          ? Colors.green.harmonizeWith(
                              Theme.of(context).colorScheme.primary,
                            )
                          : null,
                    ),
            ),
            IconButton(
              onPressed: _taskState == _TaskState.idle ? _decline : null,
              icon: _taskState == _TaskState.declining
                  ? CircularProgressIndicator(
                      color: Colors.red.harmonizeWith(
                        Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : Icon(
                      Icons.close,
                      color: _taskState == _TaskState.idle
                          ? Colors.red.harmonizeWith(
                              Theme.of(context).colorScheme.primary,
                            )
                          : null,
                    ),
            ),
          ],
        ),
      );
    } else {
      _load();
      return const ListTile(
        leading: CircularProgressIndicator(),
      );
    }
  }
}
