import 'package:flutter/material.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/pages/home/user_provider.dart';
import 'package:inventory/pages/settings/notification_settings.dart';
import 'package:inventory/pages/settings/privacy_settings.dart';
import 'package:inventory/pages/settings/profile_settings.dart';
import 'package:inventory/pages/util/auth_guard.dart';
import 'package:inventory/services/user.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool enable = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider provider = Provider.of<UserProvider>(context);
    User currentUser = provider.currentUser!;
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
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
                    currentUser.photoURL,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "${currentUser.fname} ${currentUser.lname}",
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
                const Divider(),
                ListTile(
                  title: const Text("Privacy"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacySettings(),
                        ));
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text("Notification"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationSettings(),
                        ));
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text("Sign Out"),
                  onTap: () async {
                    UserService.instance.signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthGuardScreen(),
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
