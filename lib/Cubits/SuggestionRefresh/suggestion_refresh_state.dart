part of 'suggestion_refresh_cubit.dart';

@immutable
abstract class SuggestionRefreshState {
  const SuggestionRefreshState();
}

class SuggestionRefreshInitialState extends SuggestionRefreshState {
  const SuggestionRefreshInitialState();
}

class SuggestionRefreshingState extends SuggestionRefreshState {
  const SuggestionRefreshingState();
}
