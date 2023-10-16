import 'package:chat/screens/forgot_password.dart';
import 'package:flutter/material.dart';

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({super.key});
  @override
  State<PrivacySettings> createState() => _PrivacySettings();
}

class _PrivacySettings extends State<PrivacySettings> {
  bool password = false;
  Widget build(BuildContext) {
    return Scaffold(
        appBar: AppBar(title: Text("Privacy")),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Divider(),
                ListTile(
                  title: Text("Set Password"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResetPassword()));
                  },
                )
              ],
            )));
  }
}
