part of 'imposter_pack_editor_bloc.dart';

enum ImposterPackEditorStatus {
  editing,
  saving,
  saved,
  failure,
}

class ImposterPackEditorState extends Equatable {
  const ImposterPackEditorState({
    this.editingId,
    this.name = '',
    this.category = '',
    this.words = const <WordField>[],
    this.status = ImposterPackEditorStatus.editing,
    this.errorMessage,
  });

  final String? editingId;
  final String name;
  final String category;
  final List<WordField> words;
  final ImposterPackEditorStatus status;
  final String? errorMessage;

  static const minWords = 3;

  bool get isEditing => editingId != null;

  List<String> get cleanedWords {
    return words
        .map((word) => word.text.trim())
        .where((word) => word.isNotEmpty)
        .toList();
  }

  bool get canSave {
    return name.trim().isNotEmpty &&
        category.trim().isNotEmpty &&
        cleanedWords.length >= minWords;
  }

  ImposterPackEntity toEntity() {
    return ImposterPackEntity(
      id: editingId ?? newId(),
      name: name.trim(),
      category: category.trim(),
      words: cleanedWords,
      isCustom: true,
    );
  }

  ImposterPackEditorState copyWith({
    String? editingId,
    bool preserveEditingId = true,
    String? name,
    String? category,
    List<WordField>? words,
    ImposterPackEditorStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ImposterPackEditorState(
      editingId: preserveEditingId ? (editingId ?? this.editingId) : editingId,
      name: name ?? this.name,
      category: category ?? this.category,
      words: words ?? this.words,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    editingId,
    name,
    category,
    words,
    status,
    errorMessage,
  ];
}
