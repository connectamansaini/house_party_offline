part of 'never_have_i_ever_game_bloc.dart';

class NeverHaveIEverGameState extends Equatable {
  const NeverHaveIEverGameState({
    required this.session,
    this.selectedIds = const {},
  });

  final NeverHaveIEverSession session;

  /// Players marked as matching the current prompt, pending confirmation.
  final Set<String> selectedIds;

  NeverHaveIEverGameState copyWith({
    NeverHaveIEverSession? session,
    Set<String>? selectedIds,
  }) {
    return NeverHaveIEverGameState(
      session: session ?? this.session,
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }

  @override
  List<Object?> get props => [session, selectedIds];
}
