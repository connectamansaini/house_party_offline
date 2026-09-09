import 'package:flutter/material.dart';
import 'package:house_party_offline/core/design/app_padding.dart';
import 'package:house_party_offline/core/design/spacing.dart';

/// A setup-page option: a label on the left and a segmented pick on the
/// right. Laid out with a [Wrap] rather than a [Row] so at large text sizes
/// the segments drop under the label instead of overflowing.
class SegmentedOptionRow<T> extends StatelessWidget {
  const SegmentedOptionRow({
    required this.label,
    required this.values,
    required this.labelOf,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final List<T> values;
  final String Function(T value) labelOf;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.v4,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: Spacing.lg,
        runSpacing: Spacing.xs,
        children: [
          Text(label),
          SegmentedButton<T>(
            showSelectedIcon: false,
            segments: [
              for (final option in values)
                ButtonSegment(value: option, label: Text(labelOf(option))),
            ],
            selected: {value},
            onSelectionChanged: (selection) => onChanged(selection.first),
          ),
        ],
      ),
    );
  }
}
