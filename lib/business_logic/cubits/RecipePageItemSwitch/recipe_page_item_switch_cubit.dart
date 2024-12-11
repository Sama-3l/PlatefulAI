import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'recipe_page_item_switch_state.dart';

class RecipePageItemSwitchCubit extends Cubit<RecipePageItemSwitchState> {
  RecipePageItemSwitchCubit() : super(RecipePageItemSwitchInitial());

  onDone() => emit(SwitchState());
}
