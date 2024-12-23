import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:platefulai/alogrithms/methods.dart';
import 'package:platefulai/alogrithms/widget_decider.dart';
import 'package:platefulai/business_logic/cubits/AddRecipeItem/add_recipe_item_cubit.dart';
import 'package:platefulai/business_logic/cubits/LikeAndSave/like_and_save_cubit.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/enum.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/constants/sizes.dart';
import 'package:platefulai/data/models/recipe.dart';
import 'package:platefulai/data/models/user.dart';
import 'package:platefulai/presentation/pages/recipe_add_data_page.dart';
import 'package:platefulai/presentation/pages/instructions_view.dart';
import 'package:platefulai/presentation/pages/tag_add.dart';
import 'package:platefulai/presentation/widget/action_button.dart';
import 'package:platefulai/presentation/widget/image_element.dart';
import 'package:platefulai/presentation/widget/recipe_page_widgets/recipe_list.dart';
import 'package:platefulai/presentation/widget/recipe_page_widgets/recipe_textfield.dart';
import 'package:platefulai/presentation/widget/tag_element.dart';

class RecipePage extends StatefulWidget {
  RecipePage({
    super.key,
    required this.allRecipes,
    required this.recipe,
    required this.user,
    this.editable = false,
  });

  final int allRecipes;
  final Recipe recipe;
  final UserModel user;
  final bool editable;

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final TextEditingController title = TextEditingController();

  final TextEditingController description = TextEditingController();
  Category selectedCategory = Category.Breakfast;

  final Methods func = Methods();
  final WidgetDecider wd = WidgetDecider();

  @override
  void initState() {
    super.initState();
    if (!widget.editable) {
      title.text = widget.recipe.name;
      description.text = widget.recipe.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: AppColors.backgroundWhite,
        child: SafeArea(
            top: false,
            child: BlocBuilder<AddRecipeItemCubit, AddRecipeItemState>(
              builder: (context, state) {
                return Stack(children: [
                  BlocBuilder<LikeAndSaveCubit, LikeAndSaveState>(
                    builder: (context, state) {
                      return ImageElement(options: [
                        ActionButton(size: 32, icon: CupertinoIcons.arrow_left, onTap: () => Navigator.of(context).pop()),
                        const Spacer(),
                        ActionButton(
                            size: 32,
                            icon: CupertinoIcons.heart,
                            onTap: () {
                              func.likeRecipe(context, widget.recipe, widget.user);
                              BlocProvider.of<LikeAndSaveCubit>(context).onLikeSave();
                            }),
                        kGap16,
                        ActionButton(
                            size: 32,
                            icon: widget.editable ? CupertinoIcons.check_mark : CupertinoIcons.bookmark,
                            onTap: () {
                              if (widget.editable) {
                                widget.recipe.name = title.value.text;
                                widget.recipe.description = description.value.text;
                                widget.recipe.category = selectedCategory;
                                if (widget.allRecipes < int.parse(dotenv.env["LIMIT_BACKEND"]!)) {
                                  func.alert(context, "Error", "Sorry backend limits exceeded.");
                                } else {
                                  func.publishRecipe(context, widget.recipe);
                                }
                                widget.user.myRecipes!.add(widget.recipe);
                                Navigator.of(context).pop();
                              } else {
                                func.saveRecipe(context, widget.recipe, widget.user);
                                BlocProvider.of<LikeAndSaveCubit>(context).onLikeSave();
                              }
                            }),
                      ]);
                    },
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: 0.6, // Start at 50% height
                    minChildSize: 0.6, // Minimum height is 50%
                    maxChildSize: 1.0, // Maximum height is 100%
                    builder: (context, scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: AppColors.backgroundWhite,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          shrinkWrap: true,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: RecipeTextfield(
                                  controller: title,
                                  maxLines: 2,
                                  placeholder: "Add Title",
                                  style: context.title,
                                  readOnly: !widget.editable,
                                )),
                                kGap8,
                                Text(
                                  widget.recipe.user.name,
                                  style: context.optionsBody,
                                )
                              ],
                            ),
                            kGap8,
                            GestureDetector(
                              onTap: () {
                                if (widget.editable) {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) => TagAdd(
                                            recipe: widget.recipe,
                                          )));
                                }
                              },
                              child: Row(
                                children: [
                                  TagElement(
                                    text: "${widget.recipe.time}h",
                                    icon: CupertinoIcons.clock_fill,
                                    onTap: () {},
                                    recipePage: true,
                                  ),
                                  kGap4,
                                  TagElement(
                                    text: widget.recipe.serving.toString(),
                                    icon: CupertinoIcons.person_3_fill,
                                    onTap: () {},
                                    recipePage: true,
                                  ),
                                  kGap4,
                                  TagElement(
                                    text: "${widget.recipe.calories} kcal",
                                    icon: CupertinoIcons.flame_fill,
                                    onTap: () {},
                                    recipePage: true,
                                  ),
                                  kGap4,
                                  TagElement(
                                    text: func.formatLikesAndSaves(widget.recipe.likes),
                                    icon: CupertinoIcons.heart_fill,
                                    onTap: () {},
                                    recipePage: true,
                                  ),
                                  kGap4,
                                  TagElement(
                                    text: func.formatLikesAndSaves(widget.recipe.saves),
                                    icon: CupertinoIcons.bookmark_fill,
                                    onTap: () {},
                                    recipePage: true,
                                  ),
                                ],
                              ),
                            ),
                            kGap24,
                            RecipeTextfield(
                              controller: description,
                              maxLines: 3,
                              placeholder: "Add Description",
                              style: context.body,
                              readOnly: !widget.editable,
                            ),
                            kGap24,
                            Row(
                              children: [
                                Text(
                                  "Category",
                                  style: context.subTitle,
                                ),
                                const Spacer(),
                                widget.editable
                                    ? CupertinoButton(
                                        color: AppColors.primaryGreen,
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                        onPressed: () => func.showPicker(context, selectedCategory, (option) {
                                          selectedCategory = option;
                                          BlocProvider.of<AddRecipeItemCubit>(context).onAddItemCubit();
                                        }),
                                        child: Text(
                                          selectedCategory.name,
                                          style: context.button,
                                        ),
                                      )
                                    : Text(
                                        widget.recipe.category.name,
                                        style: context.button.copyWith(color: AppColors.primaryGreen),
                                      ),
                              ],
                            ),
                            kGap24,
                            RecipeList(
                              title: "Ingredients",
                              ingredients: widget.recipe.ingredients,
                              onTap: () {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) => RecipeItemAddDataPage(
                                          user: widget.user,
                                          recipe: widget.recipe,
                                          items: widget.recipe.ingredients,
                                          title: "Ingredient",
                                          type: FieldDataType.Ingredients,
                                          onSubmit: (obj) {
                                            widget.recipe.ingredients = obj;
                                          },
                                        )));
                              },
                              editable: widget.editable,
                            ),
                            kGap24,
                            RecipeList(
                              title: "Tools",
                              tools: widget.recipe.tools,
                              onTap: () {
                                Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) => RecipeItemAddDataPage(
                                          user: widget.user,
                                          recipe: widget.recipe,
                                          items: widget.recipe.tools,
                                          title: "Tools",
                                          type: FieldDataType.Tools,
                                          onSubmit: (obj) {
                                            widget.recipe.tools = obj;
                                          },
                                        )));
                              },
                              editable: widget.editable,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  wd.showButton(
                    context,
                    widget.recipe,
                    widget.editable ? "Add/Edit Instruction" : "Instructions",
                    () {
                      if (widget.editable) {
                        Navigator.of(context).push(
                          CupertinoPageRoute(builder: (context) => InstructionsView(user: widget.user, recipe: widget.recipe, editable: widget.editable)),
                        );
                      } else {
                        Navigator.of(context).push(
                          CupertinoPageRoute(builder: (context) => InstructionsView(user: widget.user, recipe: widget.recipe, editable: widget.editable)),
                        );
                      }
                    },
                    widget.editable,
                  ),
                ]);
              },
            )));
  }
}
