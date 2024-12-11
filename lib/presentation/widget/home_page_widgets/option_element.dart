import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platefulai/alogrithms/methods.dart';
import 'package:platefulai/business_logic/cubits/LikeAndSave/like_and_save_cubit.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/constants/sizes.dart';
import 'package:platefulai/data/models/recipe.dart';
import 'package:platefulai/data/models/user.dart';
import 'package:platefulai/presentation/pages/recipe_page.dart';
import 'package:platefulai/presentation/widget/home_page_widgets/stat_element.dart';
import 'package:platefulai/presentation/widget/tag_element.dart';

class RecipeOptionElement extends StatelessWidget {
  RecipeOptionElement({
    super.key,
    required this.recipe,
    required this.currUser,
  });

  final Recipe recipe;
  final UserModel currUser;
  final Methods func = Methods();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
            builder: (context) => RecipePage(
                  recipe: recipe,
                  user: currUser,
                ))),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.14,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.25,
                decoration: BoxDecoration(
                  color: AppColors.secondarywhite,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8),
                      child: BlocBuilder<LikeAndSaveCubit, LikeAndSaveState>(
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () {
                              func.likeRecipe(context, recipe, currUser);
                              BlocProvider.of<LikeAndSaveCubit>(context).onLikeSave();
                            },
                            child: Icon(
                              recipe.likedBy != null && recipe.likedBy!.contains(currUser.id) ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                              size: 16,
                              color: AppColors.primaryGreen,
                            ),
                          );
                        },
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          color: AppColors.surfaceWhite,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          )),
                      child: BlocBuilder<LikeAndSaveCubit, LikeAndSaveState>(
                        builder: (context, state) {
                          return Row(
                            children: [
                              StatElement(
                                title: func.formatLikesAndSaves(recipe.likes),
                                icon: CupertinoIcons.heart_fill,
                              ),
                              const Spacer(),
                              StatElement(
                                title: func.formatLikesAndSaves(recipe.saves),
                                icon: CupertinoIcons.bookmark_fill,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              kGap8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: context.heading,
                    ),
                    Text(
                      recipe.user.name,
                      style: context.caption2,
                    ),
                    kGap8,
                    Row(
                      children: [
                        TagElement(
                          text: "${recipe.time}h",
                          icon: CupertinoIcons.clock_fill,
                          onTap: () {},
                        ),
                        kGap4,
                        TagElement(
                          text: recipe.serving.toString(),
                          icon: CupertinoIcons.person_3_fill,
                          onTap: () {},
                        ),
                        kGap4,
                        TagElement(
                          text: "${recipe.calories} kcal",
                          icon: CupertinoIcons.flame_fill,
                          onTap: () {},
                        )
                      ],
                    ),
                    const Spacer(),
                    Text(
                      recipe.description,
                      softWrap: true,
                      maxLines: 3,
                      style: context.optionsBody,
                    )
                  ],
                ),
              ),
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: AppColors.surfaceWhite,
                ),
                child: BlocBuilder<LikeAndSaveCubit, LikeAndSaveState>(
                  builder: (context, state) {
                    return CupertinoButton(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          recipe.savedBy != null && recipe.savedBy!.contains(currUser.id) ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
                          size: 16,
                          color: AppColors.primaryGreen,
                        ),
                        onPressed: () {
                          func.saveRecipe(context, recipe, currUser);
                          BlocProvider.of<LikeAndSaveCubit>(context).onLikeSave();
                        });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
