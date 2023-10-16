import 'package:flutter/material.dart';
import 'package:inventory/models/household.dart';
import 'package:inventory/pages/home/user_provider.dart';
import 'package:inventory/services/user.dart';
import 'package:inventory/widgets/household_tile.dart';
import 'package:provider/provider.dart';

class HouseholdList extends StatelessWidget {
  const HouseholdList({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProvider provider = Provider.of<UserProvider>(context);
    final List<Household>? households = provider.housholds;

    if (households == null) {
      provider.refresh();
    }

    if (households == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (households.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          await UserService.instance.refresh();
        },
        child: LayoutBuilder(
          builder: (context, constrains) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constrains.maxHeight,
              ),
              child: const Center(
                child: Text('You are not in any households'),
              ),
            ),
          ),
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          await UserService.instance.refresh();
        },
        child: ListView.separated(
          itemCount: households.length,
          itemBuilder: (_, index) => HouseholdTile(
            householdId: provider.currentUser!.households[index],
            household: households[index],
          ),
          separatorBuilder: (_, __) => const Divider(),
        ),
      );
    }
  }
}
