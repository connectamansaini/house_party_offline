part of 'imposter_packs_bloc.dart';

sealed class ImposterPacksEvent extends Equatable {
  const ImposterPacksEvent();

  @override
  List<Object?> get props => [];
}

class ImposterPacksStarted extends ImposterPacksEvent {
  const ImposterPacksStarted();
}

class ImposterPacksRefreshRequested extends ImposterPacksEvent {
  const ImposterPacksRefreshRequested();
}

class ImposterPackDeletedRequested extends ImposterPacksEvent {
  const ImposterPackDeletedRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
