import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platefulai/alogrithms/methods.dart';
import 'package:platefulai/business_logic/cubits/AddRecipeItem/add_recipe_item_cubit.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/constants/sizes.dart';
import 'package:platefulai/data/models/recipe.dart';
import 'package:platefulai/presentation/widget/action_button.dart';
import 'package:platefulai/presentation/widget/add_page_textfield.dart';

class TagAdd extends StatefulWidget {
  const TagAdd({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<TagAdd> createState() => _TagAddState();
}

class _TagAddState extends State<TagAdd> {
  TextEditingController timeTaken = TextEditingController();
  TextEditingController serving = TextEditingController();
  TextEditingController calorie = TextEditingController();
  final Methods func = Methods();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.recipe.time != 0) {
      timeTaken.text = widget.recipe.time.toString();
    }
    if (widget.recipe.serving != 0) {
      serving.text = widget.recipe.serving.toString();
    }
    if (widget.recipe.calories != 0) {
      calorie.text = widget.recipe.calories.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: AppColors.primaryGreen,
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Tags",
                        style: context.title.copyWith(color: AppColors.backgroundWhite),
                      ),
                      const Spacer(),
                      ActionButton(
                          size: 32,
                          icon: CupertinoIcons.check_mark,
                          onTap: () {
                            widget.recipe.time = int.parse(timeTaken.value.text);
                            widget.recipe.serving = int.parse(serving.value.text);
                            widget.recipe.calories = int.parse(calorie.value.text);
                            if (widget.recipe.id.length > 5) {
                              func.updateRecipeTags(context, widget.recipe);
                            }
                            BlocProvider.of<AddRecipeItemCubit>(context).onAddItemCubit();
                            Navigator.of(context).pop();
                          }),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        kGap24,
                        Text(
                          "Time Taken",
                          style: context.subTitle.copyWith(color: AppColors.backgroundWhite),
                        ),
                        kGap16,
                        AddPageTextfield(
                          controller: timeTaken,
                          maxLines: 1,
                          placeholder: "Time taken",
                          style: context.body,
                          inputType: TextInputType.number,
                        ),
                        kGap16,
                        AddPageTextfield(
                          controller: serving,
                          maxLines: 1,
                          placeholder: "Serving",
                          style: context.body,
                          inputType: TextInputType.number,
                        ),
                        kGap16,
                        AddPageTextfield(
                          controller: calorie,
                          maxLines: 1,
                          placeholder: "calorie",
                          style: context.body,
                          inputType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }
}
