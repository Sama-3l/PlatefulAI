// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:platefulai/data/models/recipe.dart';

class UserModel {
  String id;
  String name;
  String email;
  List<Recipe>? likedRecipes;
  List<Recipe>? savedRecipes;
  List<Recipe>? myRecipes;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.likedRecipes,
    this.savedRecipes,
    this.myRecipes,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'likedRecipes': likedRecipes?.map((x) => x.toJson()).toList(),
      'savedRecipes': savedRecipes?.map((x) => x.toJson()).toList(),
      'myRecipes': myRecipes?.map((x) => x.toJson()).toList(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] as String,
      name: map['username'] as String,
      email: map['email'] as String,
      likedRecipes: map['likedRecipes'] != null
          ? List<Recipe>.from(
              (map['likedRecipes'] as List).map<Recipe?>(
                (x) => Recipe.fromJson(x as Map<String, dynamic>),
              ),
            )
          : [],
      savedRecipes: map['savedRecipes'] != null
          ? List<Recipe>.from(
              (map['savedRecipes'] as List).map<Recipe?>(
                (x) => Recipe.fromJson(x as Map<String, dynamic>),
              ),
            )
          : [],
      myRecipes: map['myRecipes'] != null
          ? List<Recipe>.from(
              (map['myRecipes'] as List).map<Recipe?>(
                (x) => Recipe.fromJson(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }
}
