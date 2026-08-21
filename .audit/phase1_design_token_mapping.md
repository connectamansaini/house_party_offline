# Phase 1 Design Token Mapping

## Colors

- Color(0xFF7C4DFF) -> AppColorTokens.violet (seed)
- Color(0xFFFF4D8D) -> AppColorTokens.magenta
- Color(0xFF19E3D2) -> AppColorTokens.cyan
- Color(0xFFFFB020) -> AppColorTokens.amber
- Color(0xFF00C2A8) -> AppColorTokens.mint
- Color(0xFF008FC7) -> AppColorTokens.azure
- Color(0xFFC1121F) -> AppColorTokens.danger
- Color(0xFF6A040F) -> AppColorTokens.dangerDeep
- Color(0xFF3A0CA3) -> AppColorTokens.purpleDeep
- Color(0xFF10002B) -> AppColorTokens.purpleNight
- Color(0xFFFF4D6D) -> AppColorTokens.coral
- Color(0xFFB5179E) -> AppColorTokens.coralDeep
- Color(0xFFFF6D3B) -> AppColorTokens.orange

## Spacing values used in SizedBox

- 2 -> Spacing.xxs
- 4 -> Spacing.xs
- 6 -> Spacing.sm
- 8 -> Spacing.md
- 10 -> Spacing.lg
- 12 -> Spacing.xl
- 14 -> Spacing.x2l
- 16 -> Spacing.x3l
- 18 -> Spacing.x4l
- 20 -> Spacing.x5l
- 22 -> Spacing.x6l
- 24 -> Spacing.x7l
- 28 -> Spacing.x8l

## Border radius values

- 3 -> AppRadii.xs
- 4 -> AppRadii.sm
- 8 -> AppRadii.md
- 10 -> AppRadii.lg
- 12 -> AppRadii.xl
- 14 -> AppRadii.x2l
- 16 -> AppRadii.x3l
- 18 -> AppRadii.x4l
- 24 -> AppRadii.x5l
- 28 -> AppRadii.x6l

## EdgeInsets patterns mapped

- EdgeInsets.all(10) -> AppPadding.allSm
- EdgeInsets.all(16) -> AppPadding.allMd
- EdgeInsets.all(18) -> AppPadding.allLg
- EdgeInsets.all(20) -> AppPadding.allXl
- EdgeInsets.all(24) -> AppPadding.all2xl
- EdgeInsets.fromLTRB(20, 8, 20, 20) -> AppPadding.page
- EdgeInsets.fromLTRB(16, 8, 16, 8) -> AppPadding.pageCompact
- EdgeInsets.symmetric(horizontal: 16, vertical: 12) -> AppPadding.section
- EdgeInsets.symmetric(horizontal: 12, vertical: 10) -> AppPadding.chip
- EdgeInsets.symmetric(vertical: 4) -> AppPadding.v4
- EdgeInsets.symmetric(vertical: 6) -> AppPadding.v6
- EdgeInsets.symmetric(horizontal: 8, vertical: 2) -> AppPadding.h8v2

## Text style usage

- Direct TextStyle usage remains in legacy feature widgets.
- Theme baseline for card/input/chip is centralized in app/themes/app_theme.dart.
- During feature migration, each TextStyle(...) call should move to TextTheme slots and/or theme extensions.
