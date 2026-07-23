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
class CivilianRole extends Role {
  const CivilianRole({required this.secretWord, this.categoryHint});

  final String secretWord;

  @override
  final String? categoryHint;

  @override
  List<Object?> get props => [secretWord, categoryHint];
}

/// The imposter, who does not know the civilians' secret word.
///
/// - In [ImposterMode.blank] they get nothing (optionally the category hint).
/// - In [ImposterMode.undercover] they also get a [decoyWord] — a different
///   word from the same category — to help them blend in.
class ImposterRole extends Role {
  const ImposterRole({this.categoryHint, this.decoyWord});

  /// A blend-in word (Undercover mode), or null in blank mode.
  final String? decoyWord;

  @override
  final String? categoryHint;

  @override
  List<Object?> get props => [categoryHint, decoyWord];
}
