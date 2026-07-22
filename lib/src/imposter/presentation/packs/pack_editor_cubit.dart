import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/id.dart';
import '../../domain/entities/word_pack.dart';
import '../../domain/repositories/word_pack_repository.dart';

/// A single editable word row. Carries a stable [id] so text fields keep their
/// controller/cursor across rebuilds even as rows are added or removed.
class WordField extends Equatable {
  const WordField({required this.id, required this.text});

  final String id;
  final String text;

  WordField copyWith({String? text}) => WordField(id: id, text: text ?? this.text);

  @override
  List<Object?> get props => [id, text];
}

enum PackEditorStatus { editing, saving, saved }

class PackEditorState extends Equatable {
  const PackEditorState({
    this.editingId,
    this.name = '',
    this.category = '',
    this.words = const [],
    this.status = PackEditorStatus.editing,
  });

  /// Id of the pack being edited, or null when creating a new one.
  final String? editingId;
  final String name;
  final String category;
  final List<WordField> words;
  final PackEditorStatus status;

  /// Minimum words for a pack to make a playable game.
  static const minWords = 3;

  bool get isEditing => editingId != null;

  List<String> get cleanedWords =>
      words.map((w) => w.text.trim()).where((w) => w.isNotEmpty).toList();

  bool get canSave =>
      name.trim().isNotEmpty &&
      category.trim().isNotEmpty &&
      cleanedWords.length >= minWords;

  /// Builds the pack to persist. Only call when [canSave] is true.
  WordPack buildPack() => WordPack(
    id: editingId ?? newId(),
    name: name.trim(),
    category: category.trim(),
    words: cleanedWords,
    isCustom: true,
  );

  PackEditorState copyWith({
    String? name,
    String? category,
    List<WordField>? words,
    PackEditorStatus? status,
  }) {
    return PackEditorState(
      editingId: editingId,
      name: name ?? this.name,
      category: category ?? this.category,
      words: words ?? this.words,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [editingId, name, category, words, status];
}

/// Creates or edits a custom word pack.
class PackEditorCubit extends Cubit<PackEditorState> {
  PackEditorCubit(this._repository) : super(const PackEditorState());

  final WordPackRepository _repository;

  /// Loads [pack] for editing, or starts a blank pack (with a few empty rows)
  /// when null.
  void start(WordPack? pack) {
    if (pack == null) {
      emit(PackEditorState(words: _blankRows(PackEditorState.minWords)));
    } else {
      emit(
        PackEditorState(
          editingId: pack.id,
          name: pack.name,
          category: pack.category,
          words: [
            for (final w in pack.words) WordField(id: newId(), text: w),
          ],
        ),
      );
    }
  }

  void setName(String value) => emit(state.copyWith(name: value));

  void setCategory(String value) => emit(state.copyWith(category: value));

  void addWord() {
    emit(state.copyWith(words: [...state.words, _blankRow()]));
  }

  void updateWord(String id, String text) {
    emit(
      state.copyWith(
        words: [
          for (final w in state.words)
            if (w.id == id) w.copyWith(text: text) else w,
        ],
      ),
    );
  }

  void removeWord(String id) {
    emit(
      state.copyWith(words: state.words.where((w) => w.id != id).toList()),
    );
  }

  Future<void> save() async {
    if (!state.canSave) return;
    emit(state.copyWith(status: PackEditorStatus.saving));
    await _repository.saveCustomPack(state.buildPack());
    emit(state.copyWith(status: PackEditorStatus.saved));
  }

  WordField _blankRow() => WordField(id: newId(), text: '');

  List<WordField> _blankRows(int count) =>
      [for (var i = 0; i < count; i++) _blankRow()];
}
