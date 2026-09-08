part of 'most_likely_to_game_bloc.dart';

class MostLikelyToGameState extends Equatable {
  const MostLikelyToGameState({
    required this.session,
    this.selectedIds = const {},
  });

  final MostLikelyToSession session;

  /// Players marked as the group's pick for the current prompt, pending
  /// confirmation. More than one means the vote tied.
  final Set<String> selectedIds;

  MostLikelyToGameState copyWith({
    MostLikelyToSession? session,
    Set<String>? selectedIds,
  }) {
    return MostLikelyToGameState(
      session: session ?? this.session,
      selectedIds: selectedIds ?? this.selectedIds,
    );
  }

  @override
  List<Object?> get props => [session, selectedIds];
}
