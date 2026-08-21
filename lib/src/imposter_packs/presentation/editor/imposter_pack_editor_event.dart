part of 'imposter_pack_editor_bloc.dart';

sealed class ImposterPackEditorEvent extends Equatable {
  const ImposterPackEditorEvent();

  @override
  List<Object?> get props => [];
}

class ImposterPackEditorStarted extends ImposterPackEditorEvent {
  const ImposterPackEditorStarted(this.pack);

  final ImposterPackEntity? pack;

  @override
  List<Object?> get props => [pack];
}

class ImposterPackNameChanged extends ImposterPackEditorEvent {
  const ImposterPackNameChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class ImposterPackCategoryChanged extends ImposterPackEditorEvent {
  const ImposterPackCategoryChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class ImposterPackWordAdded extends ImposterPackEditorEvent {
  const ImposterPackWordAdded();
}

class ImposterPackWordChanged extends ImposterPackEditorEvent {
  const ImposterPackWordChanged({required this.id, required this.value});

  final String id;
  final String value;

  @override
  List<Object?> get props => [id, value];
}

class ImposterPackWordRemoved extends ImposterPackEditorEvent {
  const ImposterPackWordRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class ImposterPackSaveRequested extends ImposterPackEditorEvent {
  const ImposterPackSaveRequested();
}
