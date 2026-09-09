import 'package:flutter/material.dart';
import 'package:house_party_offline/src/core/prompts/prompt_language.dart';
import 'package:house_party_offline/src/core/widgets/segmented_option_row.dart';

/// The "Deck language" option shared by the prompt games' setup pages.
class PromptLanguageRow extends StatelessWidget {
  const PromptLanguageRow({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final PromptLanguage value;
  final ValueChanged<PromptLanguage> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedOptionRow<PromptLanguage>(
      label: 'Deck language',
      values: PromptLanguage.values,
      labelOf: (language) => language.label,
      value: value,
      onChanged: onChanged,
    );
  }
}
