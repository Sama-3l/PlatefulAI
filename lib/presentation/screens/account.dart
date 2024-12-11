import 'package:flutter/cupertino.dart';
import 'package:platefulai/alogrithms/methods.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/constants/sizes.dart';
import 'package:platefulai/data/models/user.dart';
import 'package:platefulai/presentation/widget/home_page_widgets/recipe_explore.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key, required this.currUser});

  final UserModel currUser;
  final Methods func = Methods();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: AppColors.backgroundWhite,
        child: SafeArea(
            child: Stack(children: [
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Account",
                    style: context.title,
                  ),
                ),
                kGap8,
                Expanded(
                    child: ListView(
                  children: [
                    Text(
                      currUser.name,
                      style: context.subTitle,
                    ),
                    Text(
                      currUser.email,
                      style: context.optionsBody,
                    ),
                    kGap40,
                    RecipeExplore(currUser: currUser, title: "My Recipes", recipes: currUser.myRecipes ?? []),
                    kGap24,
                    RecipeExplore(currUser: currUser, title: "Saved Recipes", recipes: currUser.savedRecipes ?? []),
                    kGap24,
                    RecipeExplore(currUser: currUser, title: "Liked Recipes", recipes: currUser.likedRecipes ?? []),
                  ],
                ))
              ]))
        ])));
  }
}
