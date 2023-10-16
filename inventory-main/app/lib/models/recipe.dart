import 'package:json_annotation/json_annotation.dart';

part "recipe.g.dart";

@JsonSerializable()
class Recipe {
  final String name;
  final List<String> ingredients;
  final List<String> steps;

  const Recipe({
    required this.name,
    required this.ingredients,
    required this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}
