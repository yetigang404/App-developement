import 'dart:ffi';

import 'package:chat/models/user.dart';
import 'package:chat/screens/chat/chat_settings.dart';
import 'package:chat/screens/notification_setting.dart';
import 'package:chat/screens/privacy_settings.dart';
import 'package:chat/screens/profile_settings.dart';
import 'package:chat/screens/sign_in.dart';
import 'package:chat/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool enable = false;

  User currentUser = UserService.getInstance().getCurrentUser()!;

  @override
  void initState() {
    super.initState();
    UserService.userStream.listen((event) {
      setState(() {
        if (event != null) {
          currentUser = event;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    currentUser.profilePhoto!,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "${currentUser.firstName!} ${currentUser.lastName}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    FilledButton.tonal(
                      child: const Text("Profile settings"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileSettingsPage(
                              userData: currentUser,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            Expanded(child: Container()),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Divider(),
                ListTile(
                  title: Text("Privacy"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PrivacySettings(),
                        ));
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Notification"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationSettings(),
                        ));
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Chats"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatSettings(),
                        ));
                  },
                ),
                Divider(),
                ListTile(
                  title: Text("Sign Out"),
                  onTap: () async {
                    await auth.FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignIn(),
                        ));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
