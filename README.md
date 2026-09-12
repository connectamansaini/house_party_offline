# House Party 🎉

[![CI](https://github.com/connectamansaini/house_party_offline/actions/workflows/ci.yml/badge.svg)](https://github.com/connectamansaini/house_party_offline/actions/workflows/ci.yml)

A collection of **offline party games** built with Flutter. One phone for the
room — no accounts, no internet, no second device.

## The games

| Game | How it plays | Players |
| --- | --- | --- |
| **Imposter** | Everyone gets the same secret word except the imposter. One-word clues, a vote, and one chance for the imposter to steal the win. Bundled + custom word packs, Undercover mode, secret ballots. | 3–12 |
| **Mafia** | App-moderated social deduction: role reveal, morning recaps, daytime lynch. Doctor and detective are optional. Nights run pass-and-play, or hand one person the phone as host and the app scripts the night for them, rotating the job between games. | 5–15 |
| **Never Have I Ever** | A confession is read to the room; everyone who's done it loses a life. Last player standing wins. | 2–12 |
| **Most Likely To** | A prompt, everyone points at once, the most fingers takes the point. Top score after the last round wins. | 3–12 |
| **Truth or Dare** | Pick truth or dare, face the prompt, a point for going through with it. Mild and spicy decks. | 2–12 |
| **Heads Up** | Phone on your forehead, clues from the room, a clock ticking down. Tilt down for "got it", up to pass. | 2–12 |

Across all of them:

- 👥 **One roster** — type the names once; every game's setup pre-fills them.
- ✍️ **Your own prompts** for the prompt games, kept alongside the bundled decks
  and toggled per match.
- 🃏 **Word packs** shared by Imposter and Heads Up — seven bundled, plus any you
  create in the app.
- 📳 Haptics on selection, turns, reveals and wins; screen kept awake in play.
- 🎨 Near-monochrome design with one accent per game, light and dark.
- 📖 A built-in **How to play** for every game.

---

## Tech stack

- **Flutter** (Material 3) — Dart SDK `^3.11`
- **flutter_bloc** — presentation state (a flat bloc per game, an FSM for the
  phase-based ones)
- **freezed** — immutable domain entities; **injectable** + **get_it** — DI
- **go_router** — navigation with one shared page transition
- **hive_ce** — local persistence (roster, custom prompts, packs, settings)
- **sensors_plus** — Heads Up tilt gestures; **in_app_review** — the one-time
  review ask; **wakelock_plus**
- Testing: **flutter_test**, **bloc_test**, **mocktail**

---

## Architecture

**Feature-first**, each feature layered into `data` / `domain` /
`presentation`. Game rules are **pure Dart engines** with no Flutter, BLoC, IO
or timers, so the trickiest logic is unit-tested in isolation; blocs own only
the presentation-side flow. Anything touching hardware or the platform (the
Heads Up clock and tilt sensor, the store review flow) sits behind a small
interface so tests can drive it by hand.

```
UI (widgets) → Bloc → Repository (interface) → DataSource (Hive / assets)
                 │
                 └─ pure-Dart domain: entities + engine (rules)
```

Each game is hosted on a **single route**, so the OS back button can't corrupt
a match mid-phase.

### Project structure

```
lib/
  main_*.dart                   # entrypoints per flavour
  app/                          # App root, router, DI, theme
  core/design/                  # spacing, radii, motion tokens
  src/
    core/                       # theme, shared widgets, haptics, storage
    home/                       # the games hub (featured card, grid, About)
    roster/                     # the shared player roster
    custom_prompts/             # host-written prompt decks + editor
    review/                     # the one-time store review gate
    <game>/                     # one feature per game …
      domain/                   #   entities, engine (rules)
      presentation/             #   bloc, pages, phase views
    <game>_setup/               # … and its setup form
assets/
  word_packs/                   # bundled pack JSON + index.json
test/                           # mirrors lib/ — engines, blocs, pages, repos
```

---

## Getting started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed / injectable
flutter run -t lib/main_development.dart
```

### Run the checks

The same three CI runs on every push:

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze --fatal-infos
flutter test
```

Generated files are committed; CI fails if a rebuild changes them.

### Store listing

The Play listing copy lives in [`docs/store-listing.md`](docs/store-listing.md).
The screenshots next to it are rendered from the real widgets, so after a UI
change regenerate them with:

```bash
flutter test tool/screenshots/store_screenshots_test.dart --update-goldens
```

### Adding a bundled word pack

Drop a JSON file in `assets/word_packs/` and add its filename to `index.json`:

```json
{ "id": "villains", "name": "Movie Villains", "category": "Villain",
  "words": ["Joker", "Thanos", "Sauron"] }
```

No Dart changes needed — bundled packs are read from assets at runtime, and
both Imposter and Heads Up pick them up.

### Adding a game

Mirror an existing game folder (`most_likely_to` is the smallest): a pure
engine, freezed entities, a bloc, pages, and a setup bloc. Then register it in
`app/injector`, add its routes in `app/router`, and add one entry to
`home/domain/entities/home_game.dart` — the hub, the About sheet and the
roster pick it up from there.
