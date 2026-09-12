import 'package:flutter/material.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/moment_card.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_role.dart';

/// Visual identity for a role on reveal/night cards.
typedef RoleVisual = ({Gradient gradient, MomentIcon icon, String tagline});

/// Taglines are written to the player, in the order they will act: what
/// they do tonight, then what that costs them by day.
RoleVisual roleVisual(MafiaRole role) => switch (role) {
  MafiaRole.mafia => (
    gradient: AppColors.mafiaGradient,
    icon: MomentIcon.dagger,
    tagline: 'Kill someone each night, then talk your way clear by day.',
  ),
  MafiaRole.doctor => (
    gradient: AppColors.civilianGradient,
    icon: MomentIcon.shieldCross,
    tagline: 'Save someone each night. Guess right and the mafia kill nobody.',
  ),
  MafiaRole.detective => (
    gradient: AppColors.civilianGradient,
    icon: MomentIcon.magnifier,
    tagline: 'Check someone each night and learn whose side they are on.',
  ),
  MafiaRole.villager => (
    gradient: AppColors.civilianGradient,
    icon: MomentIcon.house,
    tagline: 'No night powers — your weapons are your instincts and your vote.',
  ),
};
