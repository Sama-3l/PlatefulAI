import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'mark_step_done_state.dart';

class MarkStepDoneCubit extends Cubit<MarkStepDoneState> {
  MarkStepDoneCubit() : super(MarkStepDoneInitial());

  onDone() => emit(MarkDoneState());
}
