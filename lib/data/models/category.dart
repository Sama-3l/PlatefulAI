// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:platefulai/assets/svgs/svgs.dart';
import 'package:platefulai/constants/enum.dart';
import 'package:platefulai/data/models/recipe.dart';

class CategoryModel {
  Category name;
  String icon;
  List<Recipe> recipes;

  CategoryModel({
    required this.name,
    required this.icon,
    required this.recipes,
  });

  Map<String, dynamic> toJson() {
    String category;
    switch (name) {
      case Category.Special:
        category = "Special";
        break;
      case Category.Breakfast:
        category = "Breakfast";
        break;
      case Category.Lunch:
        category = "Lunch";
        break;
      case Category.Dinner:
        category = "Dinner";
        break;
      case Category.Pizza:
        category = "Pizza";
        break;
      case Category.Chinese:
        category = "Chinese";
        break;
      case Category.All:
        category = "All";
    }
    return <String, dynamic>{
      'name': category,
      'icon': icon,
      'recipes': recipes.map((x) => x.toJson()).toList(),
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> map) {
    Category category;
    String icon;
    switch (map['name']) {
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
      default:
        category = Category.Special;
    }
    switch (category) {
      case Category.All:
        icon = circleDotted;
      case Category.Special:
        icon = special;
      case Category.Breakfast:
        icon = breakfast;
      case Category.Lunch:
        icon = lunch;
      case Category.Dinner:
        icon = dinner;
      case Category.Pizza:
        icon = pizza;
      case Category.Chinese:
        icon = chinese;
    }
    return CategoryModel(
      name: category,
      icon: icon,
      recipes: List<Recipe>.from(
        (map['recipes'] as List).map<Recipe>(
          (x) => Recipe.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
