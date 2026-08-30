part of 'never_have_i_ever_setup_bloc.dart';

sealed class NeverHaveIEverSetupEvent extends Equatable {
  const NeverHaveIEverSetupEvent();

  @override
  List<Object?> get props => [];
}

class NeverHaveIEverSetupPlayerAdded extends NeverHaveIEverSetupEvent {
  const NeverHaveIEverSetupPlayerAdded();
}

class NeverHaveIEverSetupPlayerRemoved extends NeverHaveIEverSetupEvent {
  const NeverHaveIEverSetupPlayerRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class NeverHaveIEverSetupPlayerRenamed extends NeverHaveIEverSetupEvent {
  const NeverHaveIEverSetupPlayerRenamed({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

class NeverHaveIEverSetupLivesCountChanged extends NeverHaveIEverSetupEvent {
  const NeverHaveIEverSetupLivesCountChanged(this.count);

  final int count;

  @override
  List<Object?> get props => [count];
}
