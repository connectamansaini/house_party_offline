import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/imposter/data/models/word_pack_dto.dart';
import 'package:house_party_offline/src/imposter/domain/entities/word_pack.dart';

void main() {
  const json = {
    'id': 'foods',
    'name': 'Foods',
    'category': 'Food',
    'words': ['Pizza', 'Sushi'],
  };

  group('WordPackDto', () {
    test('round-trips through JSON', () {
      final dto = WordPackDto.fromJson(json);
      expect(dto.id, 'foods');
      expect(dto.name, 'Foods');
      expect(dto.category, 'Food');
      expect(dto.words, ['Pizza', 'Sushi']);
      expect(dto.toJson(), json);
    });

    test('reads Hive-style dynamic maps', () {
      final Map<dynamic, dynamic> map = {
        'id': 'x',
        'name': 'X',
        'category': 'Cat',
        'words': <dynamic>['a', 'b'],
      };
      final dto = WordPackDto.fromMap(map);
      expect(dto.id, 'x');
      expect(dto.words, ['a', 'b']);
    });

    test('toDomain sets the isCustom flag from the source', () {
      final bundled = WordPackDto.fromJson(json).toDomain(isCustom: false);
      expect(bundled.isCustom, isFalse);

      final custom = WordPackDto.fromJson(json).toDomain(isCustom: true);
      expect(custom.isCustom, isTrue);
    });

    test('fromDomain drops the isCustom flag (source decides it)', () {
      const pack = WordPack(
        id: 'c',
        name: 'Custom',
        category: 'Mine',
        words: ['one'],
        isCustom: true,
      );
      final dto = WordPackDto.fromDomain(pack);
      expect(dto.toJson().containsKey('isCustom'), isFalse);
    });
  });
}
