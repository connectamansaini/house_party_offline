import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_prompt.freezed.dart';

/// One host-written prompt in a game's deck.
@freezed
abstract class CustomPrompt with _$CustomPrompt {
  const factory CustomPrompt({required String id, required String text}) =
      _CustomPrompt;
}
