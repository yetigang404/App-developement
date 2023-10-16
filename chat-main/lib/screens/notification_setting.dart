import 'package:flutter/material.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  @override
  bool MasterEnable = true;
  bool PreviewEnable = true;
  bool GroupchatEnable = true;
  bool VibrationEnable = true;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(),
            ListTile(
              title: Text("All Notification"),
              trailing: Switch(
                value: MasterEnable,
                onChanged: (value) {
                  setState(() {
                    MasterEnable = value;
                  });
                },
              ),
            ),
            Divider(),
            ListTile(
              title: Text("Group-Chat Notification"),
              trailing: Switch(
                value: GroupchatEnable,
                onChanged: (value) {
                  setState(() {
                    GroupchatEnable = value;
                  });
                },
              ),
            ),
            Divider(),
            ListTile(
              title: Text("Show Previews"),
              trailing: Switch(
                value: PreviewEnable,
                onChanged: (value) {
                  setState(() {
                    PreviewEnable = value;
                  });
                },
              ),
            ),
            Divider(),
            ListTile(
              title: Text("Vibration"),
              trailing: Switch(
                value: VibrationEnable,
                onChanged: (value) {
                  setState(() {
                    VibrationEnable = value;
                  });
                },
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
