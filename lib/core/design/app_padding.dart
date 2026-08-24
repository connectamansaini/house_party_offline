import 'package:flutter/widgets.dart';

import 'package:house_party_offline/core/design/spacing.dart';

abstract final class AppPadding {
  static const allSm = EdgeInsets.all(Spacing.lg);
  static const allMd = EdgeInsets.all(Spacing.x3l);
  static const allLg = EdgeInsets.all(Spacing.x4l);
  static const allXl = EdgeInsets.all(Spacing.x5l);
  static const all2xl = EdgeInsets.all(Spacing.x7l);

  static const page = EdgeInsets.fromLTRB(20, 8, 20, 20);
  static const pageCompact = EdgeInsets.fromLTRB(16, 8, 16, 8);
  static const section = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const chip = EdgeInsets.symmetric(horizontal: 12, vertical: 10);

  static const v4 = EdgeInsets.symmetric(vertical: Spacing.xs);
  static const v6 = EdgeInsets.symmetric(vertical: Spacing.sm);
  static const h8v2 = EdgeInsets.symmetric(
    horizontal: Spacing.md,
    vertical: Spacing.xxs,
  );
}
