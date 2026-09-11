import 'package:flutter/material.dart';

/// A game's key art as a card backdrop: the image cover-fitted and a dark
/// scrim rising from the bottom so white text stays legible over any
/// picture. If the asset is missing the backdrop is simply empty and the
/// card's own dark fill shows through.
class GameArt extends StatelessWidget {
  const GameArt({required this.image, super.key});

  /// Asset path of the artwork (see `assets/images/games/`).
  final String image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          image,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.25, 1],
              colors: [Color(0x26000000), Color(0xD9000000)],
            ),
          ),
        ),
      ],
    );
  }
}
