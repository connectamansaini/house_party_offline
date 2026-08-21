part of 'imposter_packs_bloc.dart';

class ImposterPacksState extends Equatable {
  const ImposterPacksState({
    this.status = ImposterPacksStatus.initial,
    this.packs = const <ImposterPackEntity>[],
    this.errorMessage,
  });

  final ImposterPacksStatus status;
  final List<ImposterPackEntity> packs;
  final String? errorMessage;

  ImposterPacksState copyWith({
    ImposterPacksStatus? status,
    List<ImposterPackEntity>? packs,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ImposterPacksState(
      status: status ?? this.status,
      packs: packs ?? this.packs,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, packs, errorMessage];
}
