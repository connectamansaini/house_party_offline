# Game key art

One picture per game, used as the backdrop of its card on the home hub.
Wire a file up in `lib/src/home/domain/entities/home_game.dart` via the
game's `image` field; games without one show an icon chip instead.

- File name: `<game id>.png` — `imposter.png`, `mafia.png`,
  `never_have_i_ever.png`, `most_likely_to.png`, `truth_or_dare.png`,
  `heads_up.png`.
- Shape: portrait or square, roughly 800×1000 px. The card crops it to fit,
  anchored at the top, so keep the subject in the upper two thirds.
- Look: dark and moody works best — a dark scrim is drawn over the bottom
  half for white text, so light pictures wash out.
- Keep each under ~300 KB (PNG or JPEG); they ship inside the app.
