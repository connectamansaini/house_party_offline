import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_party_offline/src/home/domain/entities/home_game.dart';
import 'package:house_party_offline/src/home/domain/repositories/recent_games_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

/// Drives the games hub: which game to feature up top, based on what the
/// host opened last.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._recentGames) : super(const HomeState()) {
    on<HomeStarted>(_onStarted);
    on<HomeGameOpened>(_onGameOpened);
  }

  final RecentGamesRepository _recentGames;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    final id = await _recentGames.lastPlayedId();
    emit(state.copyWith(lastPlayedId: id, loaded: true));
  }

  Future<void> _onGameOpened(
    HomeGameOpened event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(lastPlayedId: event.gameId));
    await _recentGames.markPlayed(event.gameId);
  }
}
