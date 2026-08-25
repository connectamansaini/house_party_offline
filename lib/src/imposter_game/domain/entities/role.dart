import 'package:freezed_annotation/freezed_annotation.dart';

part 'role.freezed.dart';

/// A player's secret role for a single round.
///
/// A freezed union so an exhaustive `switch` handles every case at the
/// reveal step. [categoryHint] is declared on both variants, so freezed
/// hoists it to a common getter — `role.categoryHint` works without a
/// switch.
@freezed
sealed class Role with _$Role {
  /// A regular player who knows the secret word.
  const factory Role.civilian({
    required String secretWord,
    String? categoryHint,
  }) = CivilianRole;

  /// The imposter, who does not know the civilians' secret word.
  ///
  /// - In `ImposterMode.blank` they get nothing (optionally the category
  ///   hint).
  /// - In `ImposterMode.undercover` they also get a [decoyWord] — a
  ///   different word from the same category — to help them blend in.
  const factory Role.imposter({String? categoryHint, String? decoyWord}) =
      ImposterRole;
}
