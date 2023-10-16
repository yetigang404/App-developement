import 'package:flutter/material.dart';
import 'package:inventory/pages/home/user_provider.dart';
import 'package:inventory/widgets/invitation_tile.dart';
import 'package:provider/provider.dart';

class InvitationList extends StatefulWidget {
  const InvitationList({super.key});

  @override
  State<InvitationList> createState() => _InvitationListState();
}

class _InvitationListState extends State<InvitationList> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Invitations"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: userProvider.invitations!.length,
          itemBuilder: (_, idx) => InvitationTile(
            idx: idx,
            invitaion: userProvider.invitations![idx],
            inventoryId: userProvider.currentUser!.invitations[idx],
            onAction: (idx) {},
          ),
        ),
      ),
    );
  }
}
