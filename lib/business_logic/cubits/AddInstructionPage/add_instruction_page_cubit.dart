import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'add_instruction_page_state.dart';

class AddInstructionPageCubit extends Cubit<AddInstructionPageState> {
  AddInstructionPageCubit() : super(AddInstructionPageInitial());

  onAddPage() => emit(AddPageState());
}
