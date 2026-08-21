import 'package:freezed_annotation/freezed_annotation.dart';

part 'imposter_pack_entity.freezed.dart';

@freezed
abstract class ImposterPackEntity with _$ImposterPackEntity {
  const factory ImposterPackEntity({
    @Default('') String id,
    @Default('') String name,
    @Default('') String category,
    @Default(<String>[]) List<String> words,
    @Default(false) bool isCustom,
  }) = _ImposterPackEntity;

  static const empty = ImposterPackEntity();
}
