import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'update_textfield_state.dart';

class UpdateTextfieldCubit extends Cubit<UpdateTextfieldState> {
  UpdateTextfieldCubit() : super(UpdateTextfieldInitial());

  onUpdate() => emit(UpdateState());
}
