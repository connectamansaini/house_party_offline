import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/word_pack.dart';
import '../../domain/repositories/word_pack_repository.dart';

/// State for the word-pack list screen.
sealed class PackListState extends Equatable {
  const PackListState();

  @override
  List<Object?> get props => [];
}

class PackListLoading extends PackListState {
  const PackListLoading();
}

class PackListLoaded extends PackListState {
  const PackListLoaded(this.packs);

  final List<WordPack> packs;

  @override
  List<Object?> get props => [packs];
}

class PackListError extends PackListState {
  const PackListError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Loads and exposes the available word packs (bundled + custom).
class PackListCubit extends Cubit<PackListState> {
  PackListCubit(this._repository) : super(const PackListLoading());

  final WordPackRepository _repository;

  Future<void> load() async {
    emit(const PackListLoading());
    try {
      final packs = await _repository.getPacks();
      emit(PackListLoaded(packs));
    } catch (e) {
      emit(PackListError('Could not load word packs: $e'));
    }
  }

  /// Deletes a custom pack and refreshes the list.
  Future<void> deletePack(String id) async {
    await _repository.deleteCustomPack(id);
    await load();
  }
}
