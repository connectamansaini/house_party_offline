import 'package:equatable/equatable.dart';

/// A participant in a Mafia game. Identity only — alive/dead and role are
/// tracked by the game state, not on the player.
class MafiaPlayer extends Equatable {
  const MafiaPlayer({required this.id, required this.name});

  final String id;
  final String name;

  MafiaPlayer copyWith({String? id, String? name}) =>
      MafiaPlayer(id: id ?? this.id, name: name ?? this.name);

  @override
  List<Object?> get props => [id, name];
}
