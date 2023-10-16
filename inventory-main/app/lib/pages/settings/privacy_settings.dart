import 'package:flutter/material.dart';
import 'package:inventory/pages/home/home.dart';

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({super.key});
  @override
  State<PrivacySettings> createState() => _PrivacySettings();
}

class _PrivacySettings extends State<PrivacySettings> {
  bool password = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Divider(),
            ListTile(
              title: const Text("Set Password"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
