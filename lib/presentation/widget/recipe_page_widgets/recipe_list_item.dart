// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platefulai/business_logic/cubits/AddRecipeItem/add_recipe_item_cubit.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/data/models/ingredients.dart';
import 'package:platefulai/data/models/tool.dart';

class RecipeListItem extends StatelessWidget {
  RecipeListItem({
    super.key,
    required this.done,
    required this.title,
    required this.subTitle,
    required this.editable,
    this.ingredient,
    this.tool,
  });

  String title;
  String subTitle;
  bool done;
  bool editable;
  Ingredient? ingredient;
  Tool? tool;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.heading,
                ),
                Text(
                  subTitle,
                  style: context.caption,
                )
              ],
            ),
            const Spacer(),
            editable
                ? Container()
                : CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      done ? CupertinoIcons.check_mark_circled_solid : CupertinoIcons.check_mark_circled,
                      size: 24,
                      color: AppColors.primaryGreen,
                    ),
                    onPressed: () {
                      if (ingredient == null) {
                        tool!.done = !done;
                      } else {
                        ingredient!.done = !done;
                      }
                      BlocProvider.of<AddRecipeItemCubit>(context).onAddItemCubit();
                    })
          ],
        ));
  }
}
