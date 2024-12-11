import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'refresh_home_page_state.dart';

class RefreshHomePageCubit extends Cubit<RefreshHomePageState> {
  RefreshHomePageCubit() : super(RefreshHomePageInitial());

  onRefresh() => emit(RefreshPageState());
}
