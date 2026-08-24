import 'package:house_party_offline/src/imposter_packs/domain/entities/imposter_pack_entity.dart';
import 'package:house_party_offline/src/imposter_packs/domain/repositories/imposter_packs_repository.dart';

class GetImposterPacksUseCase {
  const GetImposterPacksUseCase(this._repository);

  final ImposterPacksRepository _repository;

  Future<List<ImposterPackEntity>> call() {
    return _repository.getPacks();
  }
}
