import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/imposter/domain/entities/word_pack.dart';
import 'package:house_party_offline/src/imposter/domain/repositories/word_pack_repository.dart';
import 'package:house_party_offline/src/imposter/presentation/packs/pack_editor_cubit.dart';

/// Records saved packs and deleted ids.
class _FakeRepo implements WordPackRepository {
  final List<WordPack> saved = [];
  final List<String> deleted = [];

  @override
  Future<List<WordPack>> getPacks() async => const [];

  @override
  Future<void> saveCustomPack(WordPack pack) async => saved.add(pack);

  @override
  Future<void> deleteCustomPack(String id) async => deleted.add(id);
}

void main() {
  group('start', () {
    test('new pack starts blank with the minimum empty rows', () {
      final cubit = PackEditorCubit(_FakeRepo())..start(null);
      final s = cubit.state;
      expect(s.isEditing, isFalse);
      expect(s.name, '');
      expect(s.words.length, PackEditorState.minWords);
      expect(s.canSave, isFalse);
    });

    test('editing loads the existing pack fields', () {
      const pack = WordPack(
        id: 'p1',
        name: 'Villains',
        category: 'Villain',
        words: ['Joker', 'Thanos', 'Sauron'],
        isCustom: true,
      );
      final cubit = PackEditorCubit(_FakeRepo())..start(pack);
      final s = cubit.state;
      expect(s.isEditing, isTrue);
      expect(s.editingId, 'p1');
      expect(s.name, 'Villains');
      expect(s.category, 'Villain');
      expect(s.words.map((w) => w.text), ['Joker', 'Thanos', 'Sauron']);
      expect(s.canSave, isTrue);
    });
  });

  group('word editing', () {
    test('add / update / remove operate by stable id', () {
      final cubit = PackEditorCubit(_FakeRepo())..start(null);
      cubit.addWord();
      final ids = cubit.state.words.map((w) => w.id).toList();

      cubit.updateWord(ids.first, 'Pizza');
      expect(cubit.state.words.first.text, 'Pizza');

      cubit.removeWord(ids.first);
      expect(cubit.state.words.any((w) => w.id == ids.first), isFalse);
    });
  });

  group('canSave', () {
    test('requires a name, a category, and enough non-empty words', () {
      final cubit = PackEditorCubit(_FakeRepo())..start(null);
      final ids = cubit.state.words.map((w) => w.id).toList();

      cubit.setName('Foods');
      cubit.setCategory('Food');
      expect(cubit.state.canSave, isFalse); // words still empty

      cubit.updateWord(ids[0], 'Pizza');
      cubit.updateWord(ids[1], '  '); // whitespace does not count
      cubit.updateWord(ids[2], 'Sushi');
      expect(cubit.state.canSave, isFalse); // only 2 real words

      cubit.addWord();
      cubit.updateWord(cubit.state.words.last.id, 'Tacos');
      expect(cubit.state.canSave, isTrue);
    });
  });

  group('save', () {
    test('persists a trimmed custom pack and marks saved', () async {
      final repo = _FakeRepo();
      final cubit = PackEditorCubit(repo)..start(null);
      final ids = cubit.state.words.map((w) => w.id).toList();
      cubit.setName('  Foods ');
      cubit.setCategory(' Food ');
      cubit.updateWord(ids[0], ' Pizza ');
      cubit.updateWord(ids[1], 'Sushi');
      cubit.updateWord(ids[2], 'Tacos');

      await cubit.save();

      expect(cubit.state.status, PackEditorStatus.saved);
      expect(repo.saved, hasLength(1));
      final pack = repo.saved.single;
      expect(pack.name, 'Foods');
      expect(pack.category, 'Food');
      expect(pack.words, ['Pizza', 'Sushi', 'Tacos']);
      expect(pack.isCustom, isTrue);
    });

    test('editing keeps the same pack id', () async {
      const existing = WordPack(
        id: 'keep-me',
        name: 'X',
        category: 'C',
        words: ['a', 'b', 'c'],
        isCustom: true,
      );
      final repo = _FakeRepo();
      final cubit = PackEditorCubit(repo)..start(existing);
      cubit.setName('X2');

      await cubit.save();

      expect(repo.saved.single.id, 'keep-me');
      expect(repo.saved.single.name, 'X2');
    });

    test('does nothing when invalid', () async {
      final repo = _FakeRepo();
      final cubit = PackEditorCubit(repo)..start(null);
      await cubit.save();
      expect(repo.saved, isEmpty);
      expect(cubit.state.status, PackEditorStatus.editing);
    });
  });
}
