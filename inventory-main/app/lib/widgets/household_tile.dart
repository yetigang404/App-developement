import 'package:flutter/material.dart';
import 'package:inventory/models/household.dart';
import 'package:inventory/pages/household/household_detail.dart';

class HouseholdTile extends StatelessWidget {
  final Household household;
  final String householdId;

  const HouseholdTile(
      {super.key, required this.household, required this.householdId});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Hero(
        tag: household,
        child: Material(
          type: MaterialType.transparency,
          child: Text(
            household.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HouseholdPage(
              household: household,
              householdId: householdId,
            ),
          ),
        );
      },
    );
  }
}
