import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:house_party_offline/src/imposter_packs/domain/entities/imposter_pack_entity.dart';
import 'package:house_party_offline/src/imposter_packs/domain/failures/imposter_packs_failure.dart';
import 'package:house_party_offline/src/imposter_packs/domain/status/imposter_packs_status.dart';
import 'package:house_party_offline/src/imposter_packs/domain/usecases/delete_custom_imposter_pack_usecase.dart';
import 'package:house_party_offline/src/imposter_packs/domain/usecases/get_imposter_packs_usecase.dart';

part 'imposter_packs_event.dart';
part 'imposter_packs_state.dart';

class ImposterPacksBloc extends Bloc<ImposterPacksEvent, ImposterPacksState> {
  ImposterPacksBloc(this._getPacks, this._deleteCustomPack)
    : super(const ImposterPacksState()) {
    on<ImposterPacksStarted>(_onStarted);
    on<ImposterPackDeletedRequested>(_onDeletedRequested);
    on<ImposterPacksRefreshRequested>(_onRefreshRequested);
  }

  final GetImposterPacksUseCase _getPacks;
  final DeleteCustomImposterPackUseCase _deleteCustomPack;

  Future<void> _onStarted(
    ImposterPacksStarted event,
    Emitter<ImposterPacksState> emit,
  ) async {
    emit(state.copyWith(status: ImposterPacksStatus.loading, clearError: true));

    try {
      final packs = await _getPacks();
      emit(
        state.copyWith(
          status: packs.isEmpty
              ? ImposterPacksStatus.empty
              : ImposterPacksStatus.success,
          packs: packs,
          clearError: true,
        ),
      );
    } on ImposterPacksFailure catch (failure) {
      emit(
        state.copyWith(
          status: ImposterPacksStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }

  Future<void> _onDeletedRequested(
    ImposterPackDeletedRequested event,
    Emitter<ImposterPacksState> emit,
  ) async {
    try {
      await _deleteCustomPack(event.id);
      add(const ImposterPacksRefreshRequested());
    } on ImposterPacksFailure catch (failure) {
      emit(
        state.copyWith(
          status: ImposterPacksStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }

  Future<void> _onRefreshRequested(
    ImposterPacksRefreshRequested event,
    Emitter<ImposterPacksState> emit,
  ) async {
    add(const ImposterPacksStarted());
  }
}
