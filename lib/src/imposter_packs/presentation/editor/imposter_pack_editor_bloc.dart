import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/id.dart';
import '../../domain/entities/imposter_pack_entity.dart';
import '../../domain/failures/imposter_packs_failure.dart';
import '../../domain/usecases/save_custom_imposter_pack_usecase.dart';

part 'imposter_pack_editor_event.dart';
part 'imposter_pack_editor_state.dart';

class WordField extends Equatable {
  const WordField({required this.id, required this.text});

  final String id;
  final String text;

  WordField copyWith({String? text}) {
    return WordField(id: id, text: text ?? this.text);
  }

  @override
  List<Object?> get props => [id, text];
}

class ImposterPackEditorBloc
    extends Bloc<ImposterPackEditorEvent, ImposterPackEditorState> {
  ImposterPackEditorBloc(this._saveCustomPack)
    : super(const ImposterPackEditorState()) {
    on<ImposterPackEditorStarted>(_onStarted);
    on<ImposterPackNameChanged>(_onNameChanged);
    on<ImposterPackCategoryChanged>(_onCategoryChanged);
    on<ImposterPackWordAdded>(_onWordAdded);
    on<ImposterPackWordChanged>(_onWordChanged);
    on<ImposterPackWordRemoved>(_onWordRemoved);
    on<ImposterPackSaveRequested>(_onSaveRequested);
  }

  final SaveCustomImposterPackUseCase _saveCustomPack;

  static const _minWords = 3;

  Future<void> _onStarted(
    ImposterPackEditorStarted event,
    Emitter<ImposterPackEditorState> emit,
  ) async {
    final pack = event.pack;
    if (pack == null) {
      emit(
        state.copyWith(
          words: [for (var i = 0; i < _minWords; i++) _blankWord()],
          status: ImposterPackEditorStatus.editing,
          clearError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        editingId: pack.id,
        name: pack.name,
        category: pack.category,
        words: [for (final w in pack.words) WordField(id: newId(), text: w)],
        status: ImposterPackEditorStatus.editing,
        clearError: true,
      ),
    );
  }

  void _onNameChanged(
    ImposterPackNameChanged event,
    Emitter<ImposterPackEditorState> emit,
  ) {
    emit(state.copyWith(name: event.value));
  }

  void _onCategoryChanged(
    ImposterPackCategoryChanged event,
    Emitter<ImposterPackEditorState> emit,
  ) {
    emit(state.copyWith(category: event.value));
  }

  void _onWordAdded(
    ImposterPackWordAdded event,
    Emitter<ImposterPackEditorState> emit,
  ) {
    emit(state.copyWith(words: [...state.words, _blankWord()]));
  }

  void _onWordChanged(
    ImposterPackWordChanged event,
    Emitter<ImposterPackEditorState> emit,
  ) {
    emit(
      state.copyWith(
        words: [
          for (final word in state.words)
            if (word.id == event.id) word.copyWith(text: event.value) else word,
        ],
      ),
    );
  }

  void _onWordRemoved(
    ImposterPackWordRemoved event,
    Emitter<ImposterPackEditorState> emit,
  ) {
    emit(
      state.copyWith(
        words: state.words.where((w) => w.id != event.id).toList(),
      ),
    );
  }

  Future<void> _onSaveRequested(
    ImposterPackSaveRequested event,
    Emitter<ImposterPackEditorState> emit,
  ) async {
    if (!state.canSave) {
      return;
    }

    emit(
      state.copyWith(status: ImposterPackEditorStatus.saving, clearError: true),
    );

    try {
      await _saveCustomPack(state.toEntity());
      emit(
        state.copyWith(
          status: ImposterPackEditorStatus.saved,
          clearError: true,
        ),
      );
    } on ImposterPacksFailure catch (failure) {
      emit(
        state.copyWith(
          status: ImposterPackEditorStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }

  WordField _blankWord() => WordField(id: newId(), text: '');
}
