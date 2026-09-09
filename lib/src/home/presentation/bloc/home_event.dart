part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the last-played game.
class HomeStarted extends HomeEvent {
  const HomeStarted();
}

/// The host tapped into a game; it becomes the featured "jump back in".
class HomeGameOpened extends HomeEvent {
  const HomeGameOpened(this.gameId);

  final String gameId;

  @override
  List<Object?> get props => [gameId];
}
