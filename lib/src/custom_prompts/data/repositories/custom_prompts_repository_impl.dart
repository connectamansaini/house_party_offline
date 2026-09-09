import 'package:house_party_offline/src/custom_prompts/data/datasources/custom_prompts_datasource.dart';
import 'package:house_party_offline/src/custom_prompts/domain/entities/custom_prompt.dart';
import 'package:house_party_offline/src/custom_prompts/domain/repositories/custom_prompts_repository.dart';

class CustomPromptsRepositoryImpl implements CustomPromptsRepository {
  CustomPromptsRepositoryImpl(this._dataSource);

  final CustomPromptsDataSource _dataSource;

  @override
  Future<List<CustomPrompt>> load(String deckId) async {
    try {
      return [
        for (final map
            in _dataSource.read(deckId) ?? const <Map<dynamic, dynamic>>[])
          if (map['id'] is String && map['text'] is String)
            CustomPrompt(id: map['id'] as String, text: map['text'] as String),
      ];
    } on Object catch (_) {
      // A corrupt deck just reads as empty — never block a setup screen.
      return const [];
    }
  }

  @override
  Future<void> save(String deckId, List<CustomPrompt> prompts) =>
      _dataSource.write(deckId, [
        for (final p in prompts) {'id': p.id, 'text': p.text},
      ]);
}
