// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:platefulai/constants/enum.dart';
import 'package:platefulai/data/models/ingredients.dart';
import 'package:platefulai/data/models/instruction.dart';
import 'package:platefulai/data/models/tool.dart';
import 'package:platefulai/data/models/user.dart';

class Recipe {
  String id;
  String name;
  String? image;
  UserModel user;
  Category category;
  String description;
  int likes;
  int saves;
  int serving;
  int time;
  int calories;
  List<String>? likedBy;
  List<String>? savedBy;
  List<Ingredient> ingredients;
  List<Tool> tools;
  List<String> tags;
  List<Instruction> instructions;

  Recipe({
    required this.id,
    required this.name,
    this.image,
    required this.user,
    required this.category,
    required this.description,
    required this.likes,
    required this.saves,
    required this.serving,
    required this.time,
    required this.calories,
    this.likedBy,
    this.savedBy,
    required this.ingredients,
    required this.tools,
    required this.tags,
    required this.instructions,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'user': user.id,
      'image': image,
      'category': category.name,
      'description': description,
      'likes': likes,
      'saves': saves,
      'serving': serving,
      'likedBy': likedBy,
      'savedBy': savedBy,
      'time': time,
      'calories': calories,
      'ingredients': ingredients.map((x) => x.toJson()).toList(),
      'tools': tools.map((x) => x.toJson()).toList(),
      'tags': tags,
      'instructions': instructions.map((x) => x.toJson()).toList(),
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> map) {
    Category category;
    switch (map['category']['name']) {
      case "Special":
        category = Category.Special;
        break;
      case "Breakfast":
        category = Category.Breakfast;
        break;
      case "Lunch":
        category = Category.Lunch;
        break;
      case "Dinner":
        category = Category.Dinner;
        break;
      case "Pizza":
        category = Category.Pizza;
        break;
      case "Chinese":
        category = Category.Chinese;
        break;
      case "All":
        category = Category.All;
        break;
      default:
        category = Category.Special;
    }
    return Recipe(
      id: map['_id'],
      name: map['name'] as String,
      image: map['image'] == null ? null : map['image'] as String,
      user: UserModel.fromJson(map['user'] as Map<String, dynamic>),
      category: category,
      description: map['description'] as String,
      likes: map['likes'] as int,
      saves: map['saves'] as int,
      serving: map['serving'] as int,
      time: map['time'] as int,
      calories: map['calories'] as int,
      likedBy: map['likedBy'] == null ? [] : (map['likedBy'] as List).map((e) => e as String).toList(),
      savedBy: map['savedBy'] == null ? [] : (map['savedBy'] as List).map((e) => e as String).toList(),
      ingredients: List<Ingredient>.from(
        (map['ingredients'] as List).map<Ingredient>(
          (x) => Ingredient.fromJson(x as Map<String, dynamic>),
        ),
      ),
      tools: List<Tool>.from(
        (map['tools'] as List).map<Tool>(
          (x) => Tool.fromJson(x as Map<String, dynamic>),
        ),
      ),
      tags: (map['tags'] as List).map((e) => e as String).toList(),
      instructions: List<Instruction>.from(
        (map['instructions'] as List).map<Instruction>(
          (x) => Instruction.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
