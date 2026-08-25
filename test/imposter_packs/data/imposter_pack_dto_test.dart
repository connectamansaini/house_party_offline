import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/imposter_packs/data/models/imposter_pack_dto.dart';
import 'package:house_party_offline/src/imposter_packs/domain/entities/imposter_pack_entity.dart';

void main() {
  const json = {
    'id': 'foods',
    'name': 'Foods',
    'category': 'Food',
    'words': ['Pizza', 'Sushi'],
    'isCustom': false,
  };

  group('ImposterPackDto', () {
    test('round-trips through JSON', () {
      final dto = ImposterPackDto.fromJson(json);
      expect(dto.id, 'foods');
      expect(dto.name, 'Foods');
      expect(dto.category, 'Food');
      expect(dto.words, ['Pizza', 'Sushi']);
      expect(dto.toJson(), json);
    });

    test('reads Hive-style dynamic maps', () {
      final map = <dynamic, dynamic>{
        'id': 'x',
        'name': 'X',
        'category': 'Cat',
        'words': <dynamic>['a', 'b'],
        'isCustom': true,
      };
      final dto = ImposterPackDto.fromMap(map);
      expect(dto.id, 'x');
      expect(dto.words, ['a', 'b']);
      expect(dto.isCustom, isTrue);
    });

    test('toEntity forces isCustom when reading from the custom box', () {
      final bundled = ImposterPackDto.fromJson(json).toEntity();
      expect(bundled.isCustom, isFalse);

      final custom = ImposterPackDto.fromJson(json).toEntity(forceCustom: true);
      expect(custom.isCustom, isTrue);
    });

    test('fromEntity preserves the entity fields', () {
      const pack = ImposterPackEntity(
        id: 'c',
        name: 'Custom',
        category: 'Mine',
        words: ['one'],
        isCustom: true,
      );
      final dto = ImposterPackDto.fromEntity(pack);
      expect(dto.id, 'c');
      expect(dto.words, ['one']);
      expect(dto.isCustom, isTrue);
    });
  });
}
