part of 'add_recipe_item_cubit.dart';

@immutable
sealed class AddRecipeItemState {}

final class AddRecipeItemInitial extends AddRecipeItemState {}

final class OnAddItemState extends AddRecipeItemState {}
