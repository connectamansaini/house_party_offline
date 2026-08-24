import 'package:house_party_offline/src/imposter_packs/domain/entities/imposter_pack_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'imposter_pack_dto.g.dart';

@JsonSerializable()
class ImposterPackDto {
  const ImposterPackDto({
    this.id = '',
    this.name = '',
    this.category = '',
    this.words = const <String>[],
    this.isCustom = false,
  });

  factory ImposterPackDto.fromEntity(ImposterPackEntity entity) {
    return ImposterPackDto(
      id: entity.id,
      name: entity.name,
      category: entity.category,
      words: entity.words,
      isCustom: entity.isCustom,
    );
  }

  factory ImposterPackDto.fromJson(Map<String, dynamic> json) =>
      _$ImposterPackDtoFromJson(json);

  factory ImposterPackDto.fromMap(Map<dynamic, dynamic> map) {
    return ImposterPackDto.fromJson(Map<String, dynamic>.from(map));
  }

  static const empty = ImposterPackDto();

  @JsonKey(defaultValue: '')
  final String id;

  @JsonKey(defaultValue: '')
  final String name;

  @JsonKey(defaultValue: '')
  final String category;

  @JsonKey(defaultValue: <String>[])
  final List<String> words;

  @JsonKey(defaultValue: false)
  final bool isCustom;

  Map<String, dynamic> toJson() => _$ImposterPackDtoToJson(this);

  ImposterPackEntity toEntity({bool forceCustom = false}) {
    return ImposterPackEntity(
      id: id,
      name: name,
      category: category,
      words: words,
      isCustom: forceCustom || isCustom,
    );
  }
}
