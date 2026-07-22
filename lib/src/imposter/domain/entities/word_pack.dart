import 'package:equatable/equatable.dart';

/// A themed set of secret words. Bundled packs ship with the app; custom packs
/// are created by users and persisted locally ([isCustom] == true).
class WordPack extends Equatable {
  const WordPack({
    required this.id,
    required this.name,
    required this.category,
    required this.words,
    this.isCustom = false,
  });

  final String id;
  final String name;

  /// Human-readable category shown as the imposter's hint when hints are on
  /// (e.g. "Food", "Places").
  final String category;

  final List<String> words;
  final bool isCustom;

  WordPack copyWith({
    String? id,
    String? name,
    String? category,
    List<String>? words,
    bool? isCustom,
  }) {
    return WordPack(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      words: words ?? this.words,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  List<Object?> get props => [id, name, category, words, isCustom];
}
