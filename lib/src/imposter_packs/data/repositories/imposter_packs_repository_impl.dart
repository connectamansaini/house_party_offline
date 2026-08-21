import '../../domain/entities/imposter_pack_entity.dart';
import '../../domain/failures/imposter_packs_failure.dart';
import '../../domain/repositories/imposter_packs_repository.dart';
import '../datasources/imposter_packs_datasource.dart';
import '../models/imposter_pack_dto.dart';

class ImposterPacksRepositoryImpl implements ImposterPacksRepository {
  ImposterPacksRepositoryImpl(this._dataSource);

  final ImposterPacksDataSource _dataSource;

  @override
  Future<List<ImposterPackEntity>> getPacks() async {
    try {
      final bundled = await _dataSource.getBundledPacks();
      final custom = await _dataSource.getCustomPacks();
      return [
        ...bundled.map((dto) => dto.toEntity()),
        ...custom.map((dto) => dto.toEntity(forceCustom: true)),
      ];
    } catch (_) {
      throw const ImposterPacksFailure(
        message: 'Could not load word packs.',
        code: 'load_failed',
      );
    }
  }

  @override
  Future<void> saveCustomPack(ImposterPackEntity pack) async {
    if (!pack.isCustom) {
      throw const ImposterPacksFailure(
        message: 'Only custom packs can be saved.',
        code: 'invalid_pack_kind',
      );
    }

    try {
      await _dataSource.saveCustomPack(ImposterPackDto.fromEntity(pack));
    } catch (_) {
      throw const ImposterPacksFailure(
        message: 'Could not save the pack.',
        code: 'save_failed',
      );
    }
  }

  @override
  Future<void> deleteCustomPack(String id) async {
    try {
      await _dataSource.deleteCustomPack(id);
    } catch (_) {
      throw const ImposterPacksFailure(
        message: 'Could not delete the pack.',
        code: 'delete_failed',
      );
    }
  }
}
