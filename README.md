# House Party 🎉

A collection of **offline, pass-and-play party games** built with Flutter. One
phone gets passed around the room — no accounts, no internet, no second device.

The first game is **Imposter** (a social word-and-bluffing game). More games will
join the hub over time.

---

## The Imposter game

Everyone secretly gets the same word — except the **imposter**, who gets nothing
(or just a category hint). Players take turns giving one-word clues, then vote on
who they think the imposter is. If the imposter is caught, they get one chance to guess
the secret word and steal the win.

**Features**
- 🎭 Full round loop: role reveal → discussion timer → voting → imposter guess → scoring
- 👥 3–12 players, host-configurable **1…N imposter** per game
- 🃏 Bundled word packs (Foods, Animals, Places, Movie Genres, Sports, Jobs) plus
  **create/edit/delete your own** custom packs
- ✅ **Multi-select packs** (with "Select all") — the secret word is drawn across
  every selected pack, and the category hint reflects the chosen word's pack
- 🕵️ **Imposter mode** — host's choice: the imposter gets *nothing* (Word
  Imposter) or a *decoy word* from the same category to blend in (Undercover)
- 🗳️ **Secret voting** (optional) — a private pass-and-play ballot that's tallied,
  instead of one shared group vote
- ⚙️ Configurable options: imposter count, category hint on/off, discussion length,
  and win points for each side
- 📖 Built-in **How to play** rules screen
- 💾 Remembers your last roster and settings between launches
- 🔒 Pass-and-play privacy covers, screen kept awake during play
- 🌗 Light & dark themes

---

## Tech stack

- **Flutter** (Material 3) — Dart SDK `^3.11`
- **flutter_bloc** — state management (Cubits for forms, a Bloc FSM for the game)
- **go_router** — navigation
- **get_it** — dependency injection
- **hive_ce** — local persistence (custom packs, settings)
- **equatable**, **uuid**, **wakelock_plus**
- Testing: **flutter_test**, **bloc_test**, **mocktail**

---

## Architecture

**Feature-first**, with each feature internally layered into `data` / `domain` /
`presentation`. BLoC lives only in the presentation layer; it talks to
repositories (domain interfaces) whose implementations live in `data`. The game
rules are **pure Dart** (`RoundEngine`) with no Flutter or BLoC dependency, so
the trickiest logic is fully unit-testable in isolation.

```
UI (widgets) → Bloc/Cubit → Repository (interface) → DataSource (Hive / assets)
                   │
                   └─ pure-Dart domain: entities + RoundEngine (rules)
```

The game itself is a **finite state machine** (`GameBloc`) hosted on a single
route, so the phases (reveal → discussion → voting → guessing → result → game
over) can't be corrupted by the OS back button.

### Project structure

```
lib/
  main.dart                     # init storage + DI, run app
  src/
    app/                        # App root, go_router, get_it wiring
    core/                       # theme, shared widgets, storage, utils, constants
    home/                       # the games hub
    imposter/                      # the Imposter game feature
      data/                     # DTOs, sources (assets + Hive), repositories
      domain/                   # entities, engine (rules), repository interfaces
      presentation/             # setup, game (FSM + phase views), packs
assets/
  word_packs/                   # bundled pack JSON + index.json
test/                           # mirrors lib/ — engine, blocs/cubits, repos
```

---

## Getting started

```bash
flutter pub get
flutter run
```

### Run the checks

```bash
flutter analyze
flutter test
```

### Adding a bundled word pack

Drop a JSON file in `assets/word_packs/` and add its filename to `index.json`:

```json
{ "id": "villains", "name": "Movie Villains", "category": "Villain",
  "words": ["Joker", "Thanos", "Sauron"] }
```

No Dart changes needed — bundled packs are read from assets at runtime.

---

## Roadmap

- More games in the hub (the "More games" tile is a placeholder)
- All-time leaderboard / match history
- App icon & branded launch screen
