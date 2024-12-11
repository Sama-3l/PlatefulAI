import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'add_item_field_state.dart';

class AddItemFieldCubit extends Cubit<AddItemFieldState> {
  AddItemFieldCubit() : super(AddItemFieldInitial());

  onAdd() => emit(AddItemState());
}
