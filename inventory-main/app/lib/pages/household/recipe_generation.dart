import 'package:flutter/material.dart';
import 'package:inventory/models/inventory.dart';
import 'package:inventory/models/recipe.dart';
import 'package:inventory/services/api.dart';
import 'package:inventory/widgets/recipe_card.dart';

class RecipePage extends StatelessWidget {
  final List<Item> inventory;
  const RecipePage({super.key, required this.inventory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Generated Recipes"),
        ),
        body: FutureBuilder<List<Recipe>>(
          future: APIService.instance.generateRecipes(inventory),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Recipe> recipes = snapshot.data!;
              return ListView.builder(
                itemBuilder: (context, idx) => RecipeCard(
                  recipe: recipes[idx],
                ),
                itemCount: recipes.length,
              );
            } else {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Generating recipes..."),
                  ],
                ),
              );
            }
          },
        ));
  }
}
