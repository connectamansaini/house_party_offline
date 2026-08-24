import 'package:house_party_offline/src/imposter/domain/entities/word_pack.dart';

/// Serializable representation of a [WordPack]. Used for bundled JSON assets
/// and for persisting custom packs in Hive.
///
/// The `isCustom` flag is not stored in the JSON body — it is determined by the
/// source (bundled assets are never custom; Hive-stored packs always are).
class WordPackDto {
  const WordPackDto({
    required this.id,
    required this.name,
    required this.category,
    required this.words,
  });

  factory WordPackDto.fromJson(Map<String, dynamic> json) {
    return WordPackDto(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      words: (json['words'] as List<dynamic>).map((w) => w as String).toList(),
    );
  }

  /// Tolerant of Hive's `Map<dynamic, dynamic>` reads.
  factory WordPackDto.fromMap(Map<dynamic, dynamic> map) {
    return WordPackDto(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      words: (map['words'] as List<dynamic>).map((w) => w as String).toList(),
    );
  }

  factory WordPackDto.fromDomain(WordPack pack) => WordPackDto(
    id: pack.id,
    name: pack.name,
    category: pack.category,
    words: pack.words,
  );

  final String id;
  final String name;
  final String category;
  final List<String> words;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'words': words,
  };

  WordPack toDomain({required bool isCustom}) => WordPack(
    id: id,
    name: name,
    category: category,
    words: words,
    isCustom: isCustom,
  );
}
