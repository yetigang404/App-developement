import 'package:flutter/material.dart';
import 'package:inventory/models/inventory.dart';
import 'package:inventory/pages/household/recipe_generation.dart';
import 'package:inventory/services/api.dart';
import 'package:inventory/widgets/common/row_input.dart';

class InventoryList extends StatefulWidget {
  final String inventoryId;
  const InventoryList({super.key, required this.inventoryId});

  @override
  State<InventoryList> createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  bool _isLoading = true;
  bool _isSyncing = false;
  List<Item> items = [];

  void removeRow(int id) {
    setState(() {
      items.removeAt(id);
    });
    sync();
  }

  void addItem(Item item) {
    setState(() {
      items.add(item);
    });
    sync();
  }

  void onChange(int idx, Item nItem) {
    setState(() {
      items[idx] = nItem;
    });
    sync();
  }

  void sync() async {
    setState(() {
      _isSyncing = true;
    });
    await APIService.instance.syncInventory(widget.inventoryId, items);
    setState(() {
      _isSyncing = false;
    });
  }

  Future<void> _loadItems() async {
    Inventory inventory = await APIService.instance.getInventory(
      widget.inventoryId,
    );
    setState(() {
      items = inventory.items;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length + 1,
                  itemBuilder: (context, idx) => idx != items.length
                      ? InventoryRowInput(
                          id: idx,
                          item: items[idx],
                          onChange: onChange,
                          onDelete: removeRow,
                        )
                      : InventoryRowInput(
                          id: idx,
                          item: null,
                          onChange: (_, __) {},
                          onDelete: (_) {},
                          isEmpty: true,
                          create: addItem,
                        ),
                ),
              ),
              if (_isSyncing) const LinearProgressIndicator(),
              if (items.length >= 10)
                FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipePage(
                            inventory: items,
                          ),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_awesome),
                        SizedBox(width: 10),
                        Text("Generate Recipes"),
                      ],
                    ))
            ],
          );
  }
}
