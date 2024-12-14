// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:platefulai/assets/svgs/svgs.dart';

import 'package:platefulai/constants/enum.dart';
import 'package:platefulai/data/models/category.dart';
import 'package:platefulai/data/models/chat.dart';
import 'package:platefulai/data/models/recipe.dart';
import 'package:platefulai/data/models/user.dart';
import 'package:platefulai/data/repo/backend_repo.dart';
import 'package:platefulai/presentation/main_app.dart';
import 'package:platefulai/presentation/widget/recipe_page_widgets/enum_picker_modal.dart';
import 'package:platefulai/utils/backend_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Methods {
  BackendRepo backendRepo = BackendRepo();
  String formatLikesAndSaves(int num) {
    return num < 500 ? num.toString() : "${num / 1000}k";
  }

  void updateToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  void showPicker(BuildContext context, Category category, Function(Category category) onSelected) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => EnumPicker(
        initialOption: category,
        onCategoryselected: (option) => onSelected(option),
      ),
    );
  }

  void alert(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(subtitle),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                // Handle the OK button press
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> handleSignIn(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (googleUser != null) {
        // Send the ID token to your backend for verification
        final String? idToken = googleAuth!.idToken;
        final response = await http.post(
          Uri.parse('${BackendConnection.baseUrl}auth/google/callback'), // Replace with your backend URL
          headers: {
            'Content-Type': 'application/json',
          },
          body: '{"idToken": "$idToken"}',
        );

        if (response.statusCode == 200) {
          // Handle success
          final String token = jsonDecode(response.body)["token"]; // JWT token from backend
          final response2 = await backendRepo.callUserGetMethod('user/getUser', token);
          updateToken(token);

          UserModel currUser = UserModel.fromJson(jsonDecode(response2.body));

          Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => MainApp(currUser: currUser)));
        } else {
          alert(context, 'Error', 'Sign up didn\'t work');
          debugPrint("Failed to sign in: ${response.body}");
        }
      }
    } catch (error) {
      alert(context, 'Error', "$error");
      debugPrint("Error signing in: $error");
    }
  }

  Future<UserModel?> verifySignIn(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final response2 = await backendRepo.callUserGetMethod('user/getUser', token!);
      UserModel currUser = UserModel.fromJson(jsonDecode(response2.body));
      return currUser;
    } catch (error) {
      alert(context, 'Error', 'Sign up didn\'t work');
      debugPrint("Error signing in: $error");
    }
    return null;
  }

  Future<List<CategoryModel>> initializeData(Category currCategory, TextEditingController search, BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final response2 = await backendRepo.callUserGetMethod('category/', token!);
      List<CategoryModel> categories = (jsonDecode(response2.body) as List).map((e) {
        return CategoryModel.fromJson(e);
      }).toList();
      categories.insert(0, CategoryModel(name: Category.All, icon: circleDotted, recipes: await getRecipes(context)));
      return categories;
    } catch (error) {
      alert(context, 'Error', 'Sign up didn\'t work');
      debugPrint("Initlizing issue $error");
      return [];
    }
  }

  Future<List<Recipe>> getRecipes(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final response2 = await backendRepo.callUserGetMethod('recipe/', token!);
      List<Recipe> recipes = (jsonDecode(response2.body) as List).map((e) {
        // debugPrint(e);
        return Recipe.fromJson(e);
      }).toList();
      return recipes;
    } catch (error) {
      debugPrint("Recipe fetch issue: $error");
      return [];
    }
  }

  Future<void> publishRecipe(BuildContext context, Recipe recipe) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final response2 = await backendRepo.callUserPostMethod(
        'recipe/addRecipe',
        recipe.toJson(),
        token!,
      );
      recipe.id = jsonDecode(response2.body)[0]["_id"].toString();
    } catch (error) {
      alert(context, "Error", "Couldn't add Recipe");
      debugPrint("Error signing in: $error");
    }
  }

  Future<void> likeRecipe(BuildContext context, Recipe recipe, UserModel currUser) async {
    try {
      if (recipe.likedBy!.contains(currUser.id)) {
        recipe.likedBy!.remove(currUser.id);
        currUser.likedRecipes!.remove(recipe);
        recipe.likes -= 1;
      } else {
        recipe.likedBy!.add(currUser.id);
        currUser.likedRecipes!.add(recipe);
        recipe.likes += 1;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      await backendRepo.callUserPostMethod(
        'recipe/like/${recipe.id}',
        {},
        token!,
      );
    } catch (error) {
      alert(context, "Error", "Couldn't add Recipe");
      debugPrint("Error signing in: $error");
    }
  }

  Future<void> saveRecipe(BuildContext context, Recipe recipe, UserModel currUser) async {
    try {
      if (recipe.savedBy!.contains(currUser.id)) {
        recipe.savedBy!.remove(currUser.id);
        currUser.savedRecipes!.remove(recipe);
        recipe.saves -= 1;
      } else {
        recipe.savedBy!.add(currUser.id);
        currUser.savedRecipes!.add(recipe);
        recipe.saves += 1;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      await backendRepo.callUserPostMethod(
        'recipe/save/${recipe.id}',
        {},
        token!,
      );
    } catch (error) {
      alert(context, "Error", "Couldn't add Recipe");
      debugPrint("Error signing in: $error");
    }
  }

  Future<void> updateRecipeTags(BuildContext context, Recipe recipe) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      await backendRepo.callUserPutMethod(
        'recipe/updateTags/${recipe.id}',
        {
          "time": recipe.time,
          "serving": recipe.serving == 0,
          "calories": recipe.calories,
        },
        token!,
      );
    } catch (error) {
      alert(context, "Error", "Couldn't add Recipe");
      debugPrint("Error signing in: $error");
    }
  }

  Future<void> sendMsg(BuildContext context, String title, String text, ScrollController scrollController, ChatModel chat, {bool submit = false}) async {
    String apiKey = dotenv.env['API_KEY']!;
    List<String> tags = [];
    if (title == FieldDataType.Steps.name) {
      tags.add("steps");
    } else if (title == FieldDataType.Ingredients.name) {
      tags.addAll([
        "name",
        "quantity"
      ]);
    } else {
      tags.addAll([
        "name",
        "use"
      ]);
    }
    String prompt = '''
      You are an AI assistant for a recipe app. Your job is to provide cooking tips, 
      recipe suggestions, and ingredient substitutions. Your responses should be concise, friendly, and 
      informative. Always help users with recipe-related queries based on their input.
      This is query is regarding $title. The user is asking this question, answer it in terms of $title. 
      The app understands that $title has ${tags.toString()} and answer in those terms only. 
      The user query is: $text''';
    try {
      if (text.isNotEmpty) {
        scrollController.animateTo(0.0, duration: const Duration(seconds: 1), curve: Curves.easeOut);
        var response = await http.post(Uri.parse("https://api.openai.com/v1/chat/completions"),
            headers: {
              "Authorization": "Bearer $apiKey",
              "Content-Type": "application/json"
            },
            body: jsonEncode({
              "model": "gpt-3.5-turbo",
              "messages": [
                {
                  "role": "user",
                  "content": prompt
                }
              ]
            }));
        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          chat.user = "SamaelAI";
          chat.chat = json["choices"][0]["message"]["content"];
          scrollController.animateTo(0.0, duration: const Duration(seconds: 1), curve: Curves.easeOut);
        }
      }
    } on Exception {
      alert(context, "Error", "Some error occurred, please try again!");
    }
  }

  Future<List<dynamic>> integrateGPT(BuildContext context, String title, String text, Function() onDone, FieldDataType type) async {
    String apiKey = dotenv.env['API_KEY']!;
    String prompt;
    List<String> tags = [];
    if (type == FieldDataType.Steps) {
      tags.add("steps");
    } else if (type == FieldDataType.Ingredients) {
      tags.addAll([
        "name",
        "quantity"
      ]);
    } else {
      tags.addAll([
        "name",
        "use"
      ]);
    }
    if (type == FieldDataType.Steps) {
      prompt = '''There is a list of items here, return a list of json of steps: $text''';
    } else {
      prompt = '''There is a list of items here, return a list of json with keys as ${tags.toString()} : $text''';
    }
    try {
      if (text.isNotEmpty) {
        var response = await http.post(Uri.parse("https://api.openai.com/v1/chat/completions"),
            headers: {
              "Authorization": "Bearer $apiKey",
              "Content-Type": "application/json"
            },
            body: jsonEncode({
              "model": "gpt-3.5-turbo",
              "messages": [
                {
                  "role": "user",
                  "content": prompt
                }
              ]
            }));
        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);
          final result = jsonDecode(json["choices"][0]["message"]["content"]);
          return result;
        }
      }
      return [];
    } on Exception {
      alert(context, "Error", "Some error occurred, please try again!");
      return [];
    }
  }
}
