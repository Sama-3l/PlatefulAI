import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'add_recipe_item_state.dart';

class AddRecipeItemCubit extends Cubit<AddRecipeItemState> {
  AddRecipeItemCubit() : super(AddRecipeItemInitial());

  onAddItemCubit() => emit(OnAddItemState());
}
