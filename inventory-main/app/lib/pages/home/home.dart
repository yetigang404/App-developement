import 'package:flutter/material.dart';
import 'package:inventory/pages/add_houshold/add_household.dart';
import 'package:inventory/pages/home/household_list.dart';
import 'package:inventory/pages/home/invitation_list.dart';
import 'package:inventory/pages/home/user_provider.dart';
import 'package:inventory/pages/settings/settings.dart';
import 'package:inventory/services/user.dart';
import 'package:inventory/widgets/inventory_list.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    const HouseholdList(),
    InventoryList(inventoryId: UserService.instance.currentUser!.inventory),
    const SettingsPage(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome ${userProvider.currentUser!.fname}!',
        ),
        actions: [
          if (userProvider.currentUser!.invitations.isNotEmpty)
            // show a dot on the icon if there are invitations
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InvitationList(),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      userProvider.currentUser!.invitations.length.toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onError,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          IconButton(
            icon: const Icon(
              Icons.add_box_outlined,
            ),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddHouseholdPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Households',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
