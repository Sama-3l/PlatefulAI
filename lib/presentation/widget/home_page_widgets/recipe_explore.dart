import 'package:flutter/cupertino.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/constants/sizes.dart';
import 'package:platefulai/data/models/recipe.dart';
import 'package:platefulai/data/models/user.dart';
import 'package:platefulai/presentation/widget/home_page_widgets/option_element.dart';

class RecipeExplore extends StatelessWidget {
  const RecipeExplore({
    super.key,
    required this.title,
    required this.currUser,
    required this.recipes,
  });

  final String title;
  final UserModel currUser;
  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.subTitle,
        ),
        kGap8,
        if (recipes.isEmpty)
          Text(
            "No Recipes",
            style: context.heading,
          ),
        if (recipes.isNotEmpty)
          ...recipes.reversed.map((e) => RecipeOptionElement(
                recipe: e,
                currUser: currUser,
              ))
      ],
    );
  }
}
