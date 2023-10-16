import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class UserAgreement extends StatefulWidget {
  const UserAgreement({super.key});

  @override
  State<UserAgreement> createState() => _UserAgreementState();
}

class _UserAgreementState extends State<UserAgreement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Agreement")),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Text(
              "The users are responsible to follow online netiquette, and if someone reports you we have the rights to go through your chat histroy and investigate. Blah Blah legal talks...",
              style: TextStyle(fontSize: 24),
            )
          ],
        ),
      ),
    );
  }
}
