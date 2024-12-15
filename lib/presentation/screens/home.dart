// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platefulai/alogrithms/methods.dart';
import 'package:platefulai/business_logic/cubits/RefreshHomePage/refresh_home_page_cubit.dart';
import 'package:platefulai/constants/colors.dart';
import 'package:platefulai/constants/enum.dart';
import 'package:platefulai/constants/extensions.dart';
import 'package:platefulai/constants/sizes.dart';
import 'package:platefulai/data/models/category.dart';
import 'package:platefulai/data/models/recipe.dart';
import 'package:platefulai/data/models/user.dart';
import 'package:platefulai/presentation/pages/recipe_page.dart';
import 'package:platefulai/presentation/widget/home_page_widgets/category_option.dart';
import 'package:platefulai/presentation/widget/home_page_widgets/recipe_explore.dart';
import 'package:platefulai/presentation/widget/home_page_widgets/textfield_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, required this.currUser});

  final UserModel currUser;

  final TextEditingController search = TextEditingController();
  final Methods func = Methods();
  Category currCategory = Category.All;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: AppColors.backgroundWhite,
        child: SafeArea(
            child: Stack(children: [
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: FutureBuilder(
                  future: func.initializeData(currCategory, search, context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return BlocBuilder<RefreshHomePageCubit, RefreshHomePageState>(
                        builder: (context, state) {
                          List<CategoryModel> allCategories = snapshot.data!;
                          CategoryModel thisCategory = allCategories.where((e) => e.name == currCategory).first;
                          return Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Home",
                                  style: context.title,
                                ),
                              ),
                              kGap24,
                              TextFieldWidget(
                                controller: search,
                                placeholder: "Search",
                                icon: const Icon(
                                  CupertinoIcons.search,
                                  size: 16,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                              kGap16,
                              Expanded(
                                  child: ListView(
                                children: [
                                  SizedBox(
                                    height: 56,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: allCategories.length,
                                      itemBuilder: (context, index) => CategoryOption(
                                        icon: allCategories[index].icon,
                                        title: allCategories[index].name,
                                        selected: currCategory == allCategories[index].name,
                                        onTap: () {
                                          currCategory = allCategories[index].name;
                                          BlocProvider.of<RefreshHomePageCubit>(context).onRefresh();
                                        },
                                      ),
                                    ),
                                  ),
                                  kGap16,
                                  thisCategory.recipes.isNotEmpty
                                      ? RecipeExplore(
                                          currUser: currUser,
                                          title: "Featured selection",
                                          recipes: thisCategory.recipes,
                                        )
                                      : Center(
                                          child: Text(
                                            "No Recipes here",
                                            style: context.heading,
                                          ),
                                        )
                                ],
                              ))
                            ],
                          );
                        },
                      );
                    } else {
                      return Column(children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Home",
                            style: context.title,
                          ),
                        ),
                        kGap24,
                        TextFieldWidget(
                          controller: search,
                          placeholder: "Search",
                          icon: const Icon(
                            CupertinoIcons.search,
                            size: 16,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        kGap16,
                        const Expanded(
                            child: Center(
                          child: CupertinoActivityIndicator(),
                        ))
                      ]);
                    }
                  })),
          Positioned(
            bottom: 32,
            right: 16,
            child: CupertinoButton(
              borderRadius: BorderRadius.circular(40),
              color: AppColors.primaryGreen,
              padding: const EdgeInsets.all(16),
              onPressed: () => Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
                  builder: (context) => RecipePage(
                        user: currUser,
                        recipe: Recipe(
                          id: "",
                          name: "",
                          user: currUser,
                          category: Category.All,
                          description: "",
                          likes: 0,
                          saves: 0,
                          serving: 0,
                          time: 0,
                          calories: 0,
                          likedBy: [],
                          savedBy: [],
                          ingredients: [],
                          tools: [],
                          tags: [],
                          instructions: [],
                        ),
                        editable: true,
                      ))),
              child: const Icon(
                CupertinoIcons.add,
              ),
            ),
          ),
        ])));
  }
}
