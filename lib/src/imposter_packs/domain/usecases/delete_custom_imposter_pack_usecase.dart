import '../repositories/imposter_packs_repository.dart';

class DeleteCustomImposterPackUseCase {
  const DeleteCustomImposterPackUseCase(this._repository);

  final ImposterPacksRepository _repository;

  Future<void> call(String id) {
    return _repository.deleteCustomPack(id);
  }
}
