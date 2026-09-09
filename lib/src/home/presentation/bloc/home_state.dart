part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({this.lastPlayedId, this.loaded = false});

  final String? lastPlayedId;

  /// False until the persisted value has been read, so the featured card
  /// doesn't flash "Start here" before switching to "Jump back in".
  final bool loaded;

  /// The last-played game, if it's still in the catalog.
  HomeGame? get lastPlayed => GameCatalog.byId(lastPlayedId);

  /// What the top card shows: the last-played game, else the first game as a
  /// "start here" suggestion.
  HomeGame get featured => lastPlayed ?? GameCatalog.games.first;

  bool get isFeaturedRecent => lastPlayed != null;

  HomeState copyWith({String? lastPlayedId, bool? loaded}) {
    return HomeState(
      lastPlayedId: lastPlayedId ?? this.lastPlayedId,
      loaded: loaded ?? this.loaded,
    );
  }

  @override
  List<Object?> get props => [lastPlayedId, loaded];
}
