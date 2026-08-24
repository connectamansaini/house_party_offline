/// Which side a role belongs to.
enum MafiaFaction { town, mafia }

/// The roles dealt in a Mafia game. The first version supports the classic
/// trio plus plain villagers.
enum MafiaRole {
  mafia,
  doctor,
  detective,
  villager;

  bool get isMafia => this == MafiaRole.mafia;

  MafiaFaction get faction => isMafia ? MafiaFaction.mafia : MafiaFaction.town;

  /// Whether this role performs an action during the night.
  bool get actsAtNight =>
      this == MafiaRole.mafia ||
      this == MafiaRole.doctor ||
      this == MafiaRole.detective;

  String get label => switch (this) {
    MafiaRole.mafia => 'Mafia',
    MafiaRole.doctor => 'Doctor',
    MafiaRole.detective => 'Detective',
    MafiaRole.villager => 'Villager',
  };
}
