import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool masterEnable = true;
  bool previewEnable = true;
  bool groupchatEnable = true;
  bool vibrationEnable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Divider(),
            ListTile(
              title: const Text("All Notification"),
              trailing: Switch(
                value: masterEnable,
                onChanged: (value) {
                  setState(() {
                    masterEnable = value;
                  });
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text("Group-Chat Notification"),
              trailing: Switch(
                value: groupchatEnable,
                onChanged: (value) {
                  setState(() {
                    groupchatEnable = value;
                  });
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text("Show Previews"),
              trailing: Switch(
                value: previewEnable,
                onChanged: (value) {
                  setState(() {
                    previewEnable = value;
                  });
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text("Vibration"),
              trailing: Switch(
                value: vibrationEnable,
                onChanged: (value) {
                  setState(() {
                    vibrationEnable = value;
                  });
                },
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
