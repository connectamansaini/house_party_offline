import 'package:house_party_offline/src/imposter_packs/domain/entities/imposter_pack_entity.dart';
import 'package:house_party_offline/src/imposter_packs/domain/repositories/imposter_packs_repository.dart';

class SaveCustomImposterPackUseCase {
  const SaveCustomImposterPackUseCase(this._repository);

  final ImposterPacksRepository _repository;

  Future<void> call(ImposterPackEntity pack) {
    return _repository.saveCustomPack(pack);
  }
}
