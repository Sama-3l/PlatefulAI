import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'like_and_save_state.dart';

class LikeAndSaveCubit extends Cubit<LikeAndSaveState> {
  LikeAndSaveCubit() : super(LikeAndSaveInitial());

  onLikeSave() => emit(LikeSaveState());
}
