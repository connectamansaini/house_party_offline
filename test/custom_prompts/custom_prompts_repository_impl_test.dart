import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/custom_prompts/data/datasources/custom_prompts_datasource.dart';
import 'package:house_party_offline/src/custom_prompts/data/repositories/custom_prompts_repository_impl.dart';
import 'package:house_party_offline/src/custom_prompts/domain/entities/custom_prompt.dart';

/// In-memory stand-in for the Hive settings box.
class _FakeDataSource implements CustomPromptsDataSource {
  final stored = <String, List<Map<dynamic, dynamic>>>{};
  bool throwOnRead = false;

  @override
  List<Map<dynamic, dynamic>>? read(String deckId) {
    if (throwOnRead) throw StateError('box closed');
    return stored[deckId];
  }

  @override
  Future<void> write(String deckId, List<Map<String, dynamic>> prompts) async =>
      stored[deckId] = prompts;
}

void main() {
  late _FakeDataSource dataSource;
  late CustomPromptsRepositoryImpl repo;

  setUp(() {
    dataSource = _FakeDataSource();
    repo = CustomPromptsRepositoryImpl(dataSource);
  });

  test('loads empty before anything is saved', () async {
    expect(await repo.load('deck'), isEmpty);
  });

  test('save then load round-trips in order, per deck', () async {
    const a = CustomPrompt(id: 'a', text: 'First');
    const b = CustomPrompt(id: 'b', text: 'Second');

    await repo.save('one', [a, b]);
    await repo.save('two', [b]);

    expect(await repo.load('one'), [a, b]);
    expect(await repo.load('two'), [b]);
  });

  test('skips malformed entries and survives a read failure', () async {
    dataSource.stored['deck'] = [
      {'id': 'ok', 'text': 'Fine'},
      {'id': 42, 'text': 'Bad id'},
      {'text': 'No id'},
    ];
    expect(await repo.load('deck'), [
      const CustomPrompt(id: 'ok', text: 'Fine'),
    ]);

    dataSource.throwOnRead = true;
    expect(await repo.load('deck'), isEmpty);
  });
}
