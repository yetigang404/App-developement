import 'package:flutter/material.dart';
import 'package:inventory/models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(recipe.name),
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      childrenPadding: const EdgeInsets.all(8),
      children: [
        const Text("Ingredients:",
            style: TextStyle(fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: recipe.ingredients
                .map(
                  (e) => Text(
                    "• $e",
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 8),
        const Text("Steps:", style: TextStyle(fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: recipe.steps
                .map(
                  (e) => Text(e),
                )
                .toList(),
          ),
        )
      ],
    );
  }
}
