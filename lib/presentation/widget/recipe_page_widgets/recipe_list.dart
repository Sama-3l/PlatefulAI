// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platefulai/alogrithms/widget_decider.dart';
import 'package:platefulai/business_logic/cubits/AddRecipeItem/add_recipe_item_cubit.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/constants/sizes.dart';
import 'package:platefulai/data/models/ingredients.dart';
import 'package:platefulai/data/models/tool.dart';

class RecipeList extends StatelessWidget {
  RecipeList({
    super.key,
    required this.title,
    required this.onTap,
    this.editable = false,
    this.ingredients,
    this.tools,
  });

  final String title;
  final Function() onTap;
  final bool editable;
  List<Ingredient>? ingredients;
  List<Tool>? tools;
  final WidgetDecider wd = WidgetDecider();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              title,
              style: context.subTitle,
            ),
            const Spacer(),
            editable
                ? CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(
                      CupertinoIcons.plus_circle_fill,
                      size: 24,
                    ),
                    onPressed: () => onTap())
                // ingredients == null ? tools!.add(Tool(name: "AIDAD", use: "AWDIAIWUDBIA", done: false)) : ingredients!.add(Ingredient(name: "HELLLLLLO", quantity: "2", done: false));
                // BlocProvider.of<AddRecipeItemCubit>(context).onAddItemCubit();
                : ingredients == null
                    ? CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          tools!.every((tool) => tool.done) ? CupertinoIcons.check_mark_circled_solid : CupertinoIcons.check_mark_circled,
                          size: 24,
                          color: AppColors.primaryGreen,
                        ),
                        onPressed: () {
                          bool allDone = tools!.every((tool) => tool.done);
                          tools!.forEach((e) => e.done = !allDone);
                          BlocProvider.of<AddRecipeItemCubit>(context).onAddItemCubit();
                        })
                    : CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          ingredients!.every((ingredient) => ingredient.done) ? CupertinoIcons.check_mark_circled_solid : CupertinoIcons.check_mark_circled,
                          size: 24,
                          color: AppColors.primaryGreen,
                        ),
                        onPressed: () {
                          bool allDone = ingredients!.every((ingredient) => ingredient.done);
                          ingredients!.forEach((e) => e.done = !allDone);
                          BlocProvider.of<AddRecipeItemCubit>(context).onAddItemCubit();
                        }),
          ],
        ),
        kGap16,
        ...wd.renderIngredientsOrTools(context, ingredients, tools, editable),
      ],
    );
  }
}
