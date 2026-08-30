part of 'never_have_i_ever_game_bloc.dart';

sealed class NeverHaveIEverGameEvent extends Equatable {
  const NeverHaveIEverGameEvent();

  @override
  List<Object?> get props => [];
}

/// Toggles whether a player matches the current prompt.
class NeverHaveIEverPlayerToggled extends NeverHaveIEverGameEvent {
  const NeverHaveIEverPlayerToggled(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

/// Docks a life from everyone selected and advances to the next prompt.
class NeverHaveIEverRoundConfirmed extends NeverHaveIEverGameEvent {
  const NeverHaveIEverRoundConfirmed();
}
