import 'package:flutter/material.dart';
import 'package:inventory/widgets/inventory_list.dart';

class InventoryDetail extends StatelessWidget {
  final String inventoryId;

  const InventoryDetail({super.key, required this.inventoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InventoryList(
          inventoryId: inventoryId,
        ),
      ),
    );
  }
}
