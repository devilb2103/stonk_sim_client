import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'suggestion_refresh_state.dart';

class SuggestionRefreshCubit extends Cubit<SuggestionRefreshState> {
  SuggestionRefreshCubit() : super(const SuggestionRefreshInitialState());

  void refreshSuggestionUI() {
    emit(const SuggestionRefreshingState());
    emit(const SuggestionRefreshInitialState());
  }
}
