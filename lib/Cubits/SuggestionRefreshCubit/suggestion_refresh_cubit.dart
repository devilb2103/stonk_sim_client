import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:stonk_sim_client/network_vars.dart';

part 'suggestion_refresh_state.dart';

class SuggestionRefreshCubit extends Cubit<SuggestionRefreshState> {
  SuggestionRefreshCubit() : super(const SuggestionRefreshInitialState());

  final dio = Dio();

  Future<void> refreshSuggestionUI(String ticker) async {
    String queryData = ticker;
    emit(const SuggestionRefreshingState());
    try {
      if (queryData.isNotEmpty) {
        final data = await dio.get(reccAddress + ticker);
        suggestions = data.data;
      } else {
        suggestions = [];
      }
    } catch (e) {}
    emit(const SuggestionRefreshingState());
    emit(const SuggestionRefreshInitialState());
  }
}
