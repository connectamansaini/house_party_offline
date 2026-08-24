import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/imposter_packs/domain/entities/imposter_pack_entity.dart';
import 'package:house_party_offline/src/imposter_packs/domain/repositories/imposter_packs_repository.dart';
import 'package:house_party_offline/src/imposter_packs/domain/usecases/save_custom_imposter_pack_usecase.dart';
import 'package:house_party_offline/src/imposter_packs/presentation/editor/imposter_pack_editor_bloc.dart';

/// Records saved packs so the editor's output can be asserted on.
class _FakeRepository implements ImposterPacksRepository {
  final List<ImposterPackEntity> saved = <ImposterPackEntity>[];

  @override
  Future<List<ImposterPackEntity>> getPacks() async =>
      const <ImposterPackEntity>[];

  @override
  Future<void> saveCustomPack(ImposterPackEntity pack) async => saved.add(pack);

  @override
  Future<void> deleteCustomPack(String id) async {}
}

/// Builds the bloc and drains the events added by [setUp] so each test starts
/// from a settled state.
Future<ImposterPackEditorBloc> _started(
  _FakeRepository repository, {
  ImposterPackEntity? pack,
}) async {
  final bloc = ImposterPackEditorBloc(SaveCustomImposterPackUseCase(repository))
    ..add(ImposterPackEditorStarted(pack));
  await bloc.stream.first;
  return bloc;
}

Future<void> _settle(ImposterPackEditorBloc bloc) =>
    Future<void>.delayed(Duration.zero);

void main() {
  group('start', () {
    test('a new pack starts blank with the minimum empty rows', () async {
      final bloc = await _started(_FakeRepository());
      final state = bloc.state;

      expect(state.isEditing, isFalse);
      expect(state.name, '');
      expect(state.words.length, ImposterPackEditorState.minWords);
      expect(state.canSave, isFalse);

      await bloc.close();
    });

    test('editing loads the existing pack fields', () async {
      const pack = ImposterPackEntity(
        id: 'p1',
        name: 'Villains',
        category: 'Villain',
        words: ['Joker', 'Thanos', 'Sauron'],
        isCustom: true,
      );
      final bloc = await _started(_FakeRepository(), pack: pack);
      final state = bloc.state;

      expect(state.isEditing, isTrue);
      expect(state.editingId, 'p1');
      expect(state.name, 'Villains');
      expect(state.category, 'Villain');
      expect(state.words.map((w) => w.text), ['Joker', 'Thanos', 'Sauron']);
      expect(state.canSave, isTrue);

      await bloc.close();
    });
  });

  group('word editing', () {
    test('add / update / remove operate by stable id', () async {
      final bloc = await _started(_FakeRepository())
        ..add(const ImposterPackWordAdded());
      await _settle(bloc);
      final ids = bloc.state.words.map((w) => w.id).toList();

      bloc.add(ImposterPackWordChanged(id: ids.first, value: 'Pizza'));
      await _settle(bloc);
      expect(bloc.state.words.first.text, 'Pizza');

      bloc.add(ImposterPackWordRemoved(ids.first));
      await _settle(bloc);
      expect(bloc.state.words.any((w) => w.id == ids.first), isFalse);

      await bloc.close();
    });
  });

  group('canSave', () {
    test('requires a name, a category, and enough non-empty words', () async {
      final bloc = await _started(_FakeRepository());
      final ids = bloc.state.words.map((w) => w.id).toList();

      bloc
        ..add(const ImposterPackNameChanged('Foods'))
        ..add(const ImposterPackCategoryChanged('Food'));
      await _settle(bloc);
      expect(bloc.state.canSave, isFalse, reason: 'words are still empty');

      bloc
        ..add(ImposterPackWordChanged(id: ids[0], value: 'Pizza'))
        // Whitespace does not count towards the minimum.
        ..add(ImposterPackWordChanged(id: ids[1], value: '  '))
        ..add(ImposterPackWordChanged(id: ids[2], value: 'Sushi'));
      await _settle(bloc);
      expect(bloc.state.canSave, isFalse, reason: 'only two real words');

      bloc.add(const ImposterPackWordAdded());
      await _settle(bloc);
      bloc.add(
        ImposterPackWordChanged(id: bloc.state.words.last.id, value: 'Tacos'),
      );
      await _settle(bloc);
      expect(bloc.state.canSave, isTrue);

      await bloc.close();
    });
  });

  group('save', () {
    test('persists a trimmed custom pack and marks saved', () async {
      final repository = _FakeRepository();
      final bloc = await _started(repository);
      final ids = bloc.state.words.map((w) => w.id).toList();

      bloc
        ..add(const ImposterPackNameChanged('  Foods '))
        ..add(const ImposterPackCategoryChanged(' Food '))
        ..add(ImposterPackWordChanged(id: ids[0], value: ' Pizza '))
        ..add(ImposterPackWordChanged(id: ids[1], value: 'Sushi'))
        ..add(ImposterPackWordChanged(id: ids[2], value: 'Tacos'))
        ..add(const ImposterPackSaveRequested());
      await bloc.stream.firstWhere(
        (state) => state.status == ImposterPackEditorStatus.saved,
      );

      expect(repository.saved, hasLength(1));
      final pack = repository.saved.single;
      expect(pack.name, 'Foods');
      expect(pack.category, 'Food');
      expect(pack.words, ['Pizza', 'Sushi', 'Tacos']);
      expect(pack.isCustom, isTrue);

      await bloc.close();
    });

    test('editing keeps the same pack id', () async {
      const existing = ImposterPackEntity(
        id: 'keep-me',
        name: 'X',
        category: 'C',
        words: ['a', 'b', 'c'],
        isCustom: true,
      );
      final repository = _FakeRepository();
      final bloc = await _started(repository, pack: existing);

      bloc
        ..add(const ImposterPackNameChanged('X2'))
        ..add(const ImposterPackSaveRequested());
      await bloc.stream.firstWhere(
        (state) => state.status == ImposterPackEditorStatus.saved,
      );

      expect(repository.saved.single.id, 'keep-me');
      expect(repository.saved.single.name, 'X2');

      await bloc.close();
    });

    test('does nothing when the form is invalid', () async {
      final repository = _FakeRepository();
      final bloc = await _started(repository)
        ..add(const ImposterPackSaveRequested());
      await _settle(bloc);

      expect(repository.saved, isEmpty);
      expect(bloc.state.status, ImposterPackEditorStatus.editing);

      await bloc.close();
    });
  });
}
