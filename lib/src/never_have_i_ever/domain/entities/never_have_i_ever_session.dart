import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:house_party_offline/src/never_have_i_ever/domain/entities/never_have_i_ever_player.dart';

part 'never_have_i_ever_session.freezed.dart';

/// The live state of an in-progress match: the roster, each player's
/// remaining lives, and the shuffled prompt deck.
@freezed
abstract class NeverHaveIEverSession with _$NeverHaveIEverSession {
  const factory NeverHaveIEverSession({
    required List<NeverHaveIEverPlayer> players,
    required Map<String, int> lives,
    required List<String> deck,
    required int promptIndex,
  }) = _NeverHaveIEverSession;

  const NeverHaveIEverSession._();

  /// The prompt currently on screen. The deck loops (via modulo) if a match
  /// runs longer than the bundled prompt count.
  String get currentPrompt => deck[promptIndex % deck.length];

  List<NeverHaveIEverPlayer> get alivePlayers =>
      players.where((p) => (lives[p.id] ?? 0) > 0).toList();

  List<NeverHaveIEverPlayer> get eliminatedPlayers =>
      players.where((p) => (lives[p.id] ?? 0) <= 0).toList();

  /// The match ends once one player remains — or zero, if the last two were
  /// eliminated in the same round.
  bool get isOver => alivePlayers.length <= 1;

  /// Null when the match ended in a full wipeout instead of a single winner.
  NeverHaveIEverPlayer? get winner =>
      alivePlayers.length == 1 ? alivePlayers.first : null;
}
