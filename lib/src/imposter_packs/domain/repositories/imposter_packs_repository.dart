import 'package:house_party_offline/src/imposter_packs/domain/entities/imposter_pack_entity.dart';

abstract interface class ImposterPacksRepository {
  Future<List<ImposterPackEntity>> getPacks();
  Future<void> saveCustomPack(ImposterPackEntity pack);
  Future<void> deleteCustomPack(String id);
}
