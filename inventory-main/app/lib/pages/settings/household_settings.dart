import 'package:flutter/material.dart';
import 'package:inventory/pages/home/user_provider.dart';
import 'package:inventory/pages/settings/profile_settings.dart';
import 'package:provider/provider.dart';

class HouseholdSettings extends StatefulWidget {
  const HouseholdSettings({super.key});

  @override
  State<HouseholdSettings> createState() => _HouseholdSettingsState();
}

class _HouseholdSettingsState extends State<HouseholdSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Household Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Divider(),
            ListTile(
              title: const Text("Change Household Name"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileSettingsPage(
                      userData: Provider.of<UserProvider>(context).currentUser!,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Edit Household Members"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileSettingsPage(
                      userData: Provider.of<UserProvider>(context).currentUser!,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Chage Household Image"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileSettingsPage(
                      userData: Provider.of<UserProvider>(context).currentUser!,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
