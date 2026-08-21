// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imposter_pack_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImposterPackDto _$ImposterPackDtoFromJson(Map<String, dynamic> json) =>
    ImposterPackDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      words:
          (json['words'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      isCustom: json['isCustom'] as bool? ?? false,
    );

Map<String, dynamic> _$ImposterPackDtoToJson(ImposterPackDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'words': instance.words,
      'isCustom': instance.isCustom,
    };
