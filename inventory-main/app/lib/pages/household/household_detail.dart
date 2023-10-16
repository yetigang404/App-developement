import 'package:flutter/material.dart';
import 'package:inventory/models/household.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/pages/add_houshold/add_members.dart';
import 'package:inventory/pages/household/inventory_detail.dart';
import 'package:inventory/pages/settings/settings.dart';
import 'package:inventory/services/api.dart';

class HouseholdPage extends StatefulWidget {
  final Household household;

  final String householdId;
  const HouseholdPage(
      {super.key, required this.household, required this.householdId});

  @override
  State<HouseholdPage> createState() => _HouseholdPageState();
}

class _HouseholdPageState extends State<HouseholdPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: widget.household,
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              widget.household.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: const Text('Inventory'),
              subtitle: const Text('View the inventory'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InventoryDetail(
                      inventoryId: widget.household.inventory,
                    ),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Members'),
              subtitle: const Text('Manage and add members'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddMembersPage(
                        householdName: widget.household.name,
                        initialUserIds: widget.household.members,
                        submitLabel: "Done",
                        onSubmit: (users) async {
                          Navigator.pop(context);
                          APIService.instance.editMembers(
                            household: widget.household,
                            householdId: widget.householdId,
                            members: users.whereType<User>().toList(),
                          );
                        }),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Settings'),
              subtitle: const Text('Manage household'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Navigator.push(context, );
              },
            ),
          ),
        ],
      ),
    );
  }
}
