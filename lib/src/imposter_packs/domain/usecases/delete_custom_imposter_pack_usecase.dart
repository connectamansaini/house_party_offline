import 'package:house_party_offline/src/imposter_packs/domain/repositories/imposter_packs_repository.dart';

class DeleteCustomImposterPackUseCase {
  const DeleteCustomImposterPackUseCase(this._repository);

  final ImposterPacksRepository _repository;

  Future<void> call(String id) {
    return _repository.deleteCustomPack(id);
  }
}
