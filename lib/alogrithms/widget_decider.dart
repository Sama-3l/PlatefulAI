import 'package:flutter/cupertino.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/data/models/ingredients.dart';
import 'package:platefulai/data/models/recipe.dart';
import 'package:platefulai/data/models/tool.dart';
import 'package:platefulai/presentation/widget/recipe_page_widgets/recipe_list_item.dart';

class WidgetDecider {
  List<Widget> renderIngredientsOrTools(BuildContext context, List<Ingredient>? ingredients, List<Tool>? tools, bool editable) {
    if (ingredients == null) {
      return tools!.isEmpty
          ? [
              Text(
                "No Tools",
                style: context.heading,
              )
            ]
          : tools
              .map((e) => RecipeListItem(
                    title: e.name,
                    subTitle: e.use,
                    done: e.done,
                    tool: e,
                    editable: editable,
                  ))
              .toList();
    } else {
      return ingredients.isEmpty
          ? [
              Text(
                "No Ingredients",
                style: context.heading,
              )
            ]
          : ingredients
              .map((e) => RecipeListItem(
                    title: e.name,
                    subTitle: e.quantity,
                    done: e.done,
                    ingredient: e,
                    editable: editable,
                  ))
              .toList();
    }
  }

  Widget showButton(BuildContext context, Recipe recipe, String title, Function() onTap, bool showButton) {
    if (showButton || recipe.ingredients.every((ingredient) => ingredient.done) && recipe.tools.every((tool) => tool.done)) {
      return Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: CupertinoButton(
            color: AppColors.primaryGreen,
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              title,
              style: context.button,
            ),
            onPressed: () => onTap(),
          ));
    }
    return Container();
  }
}
