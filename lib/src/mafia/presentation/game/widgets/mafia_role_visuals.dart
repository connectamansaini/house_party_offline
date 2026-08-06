import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../domain/entities/mafia_role.dart';

/// Visual identity for a role on reveal/night cards.
typedef RoleVisual = ({Gradient gradient, IconData icon, String tagline});

RoleVisual roleVisual(MafiaRole role) => switch (role) {
  MafiaRole.mafia => (
    gradient: AppColors.mafiaGradient,
    icon: Icons.dangerous_rounded,
    tagline: 'Kill quietly at night. Blend in by day.',
  ),
  MafiaRole.doctor => (
    gradient: AppColors.civilianGradient,
    icon: Icons.healing_rounded,
    tagline: 'Protect one player from the mafia each night.',
  ),
  MafiaRole.detective => (
    gradient: AppColors.civilianGradient,
    icon: Icons.search_rounded,
    tagline: 'Investigate one player each night.',
  ),
  MafiaRole.villager => (
    gradient: AppColors.civilianGradient,
    icon: Icons.groups_rounded,
    tagline: 'No night powers — root out the mafia by day.',
  ),
};
