import 'package:flutter/material.dart';
import 'package:house_party_offline/src/core/theme/app_colors.dart';
import 'package:house_party_offline/src/core/widgets/moment_card.dart';
import 'package:house_party_offline/src/mafia_game/domain/entities/mafia_role.dart';

/// Visual identity for a role on reveal/night cards.
typedef RoleVisual = ({Gradient gradient, MomentIcon icon, String tagline});

RoleVisual roleVisual(MafiaRole role) => switch (role) {
  MafiaRole.mafia => (
    gradient: AppColors.mafiaGradient,
    icon: MomentIcon.dagger,
    tagline: 'Kill quietly at night. Blend in by day.',
  ),
  MafiaRole.doctor => (
    gradient: AppColors.civilianGradient,
    icon: MomentIcon.shieldCross,
    tagline: 'Protect one player from the mafia each night.',
  ),
  MafiaRole.detective => (
    gradient: AppColors.civilianGradient,
    icon: MomentIcon.magnifier,
    tagline: 'Investigate one player each night.',
  ),
  MafiaRole.villager => (
    gradient: AppColors.civilianGradient,
    icon: MomentIcon.house,
    tagline: 'No night powers — root out the mafia by day.',
  ),
};
