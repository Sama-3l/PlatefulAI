import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'chat_page_update_state.dart';

class ChatPageUpdateCubit extends Cubit<ChatPageUpdateState> {
  ChatPageUpdateCubit() : super(ChatPageUpdateInitial());

  onUpdate() => emit(ChatUpdate());
  onWaitingForAI() => emit(WaitingForAI());
}
