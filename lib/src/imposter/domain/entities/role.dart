import 'package:equatable/equatable.dart';

/// A player's secret role for a single round.
///
/// Sealed so exhaustive `switch` handles every case at the reveal step.
sealed class Role extends Equatable {
  const Role();

  /// The category hint to display, or null when hints are disabled.
  String? get categoryHint;
}

/// A regular player who knows the secret word.
class CrewRole extends Role {
  const CrewRole({required this.secretWord, this.categoryHint});

  final String secretWord;

  @override
  final String? categoryHint;

  @override
  List<Object?> get props => [secretWord, categoryHint];
}

/// The imposter, who does not know the secret word. May receive the category
/// hint when [GameConfig.categoryHintEnabled] is true.
class ImposterRole extends Role {
  const ImposterRole({this.categoryHint});

  @override
  final String? categoryHint;

  @override
  List<Object?> get props => [categoryHint];
}
