# Play Store listing

Copy for the Google Play listing of `com.makeanapplikeus.house_party_offline`.
Paste each block into the matching Play Console field. Character limits are
Play's; the counts here are for the text as written.

## App name (30 max)

```
House Party: Offline Games
```

## Short description (80 max)

```
6 party games on one phone. No internet, no accounts, no second device.
```

## Full description (4000 max)

```
Six party games on one phone. No internet, no accounts, nothing to sign up for. Pass the phone around the room and play.

THE GAMES

🎭 Imposter (3–12 players)
Everyone gets the same secret word, except the imposter. Go round the room with one-word clues, vote on who is bluffing, and give the imposter one last chance to guess the word and steal the win. Six bundled word packs, your own custom packs, an Undercover mode and secret ballots.

🕵️ Mafia (5–15 players)
Social deduction, moderated by the app. Role reveal, a morning recap of what happened overnight, then a daytime vote. Root out the mafia before they take the town. Choose whether a doctor and a detective are in the deal. Play it pass-and-play, or switch on host mode: one person keeps the phone, reads out each step, and taps in what the room points at — no more passing round a big group. Rotate the host and the job moves to the next person each game.

🙈 Never Have I Ever (2–12 players)
A confession is read to the room. Everyone who has done it loses a life. Last player standing wins.

👉 Most Likely To (3–12 players)
Hear a prompt, everyone points at once. The most fingers takes the point. Top score after the last round wins.

🔥 Truth or Dare (2–12 players)
Pick truth or dare, face the prompt, and earn a point for going through with it. Mild and spicy decks, so you choose how far the night goes.

🙌 Heads Up (2–12 players)
Phone on your forehead, clues from the room, a clock ticking down. Tilt down for "got it", tilt up to pass. Uses the same word packs as Imposter.

MADE FOR THE ROOM

• One roster. Type the players' names once and every game's setup fills them in.
• English and Hinglish decks for Never Have I Ever, Most Likely To and Truth or Dare. Pick the one your room speaks.
• Your own prompts. Add inside jokes to Never Have I Ever, Most Likely To and Truth or Dare, kept alongside the bundled decks and switched on per match.
• Seven word packs for Imposter and Heads Up, Bollywood included, plus any you create.
• A built-in "How to play" for every game, so nobody has to explain the rules.
• Haptic feedback on turns, reveals and wins. The screen stays awake while you play.
• A clean, near-monochrome design with one accent colour per game. Light and dark.
• Works with large text sizes and the "remove animations" setting.

TRULY OFFLINE

House Party never needs a connection. There are no accounts, no ads, no tracking and nothing leaves your phone. Player names and custom content stay on the device.

Perfect for house parties, road trips, camping, hostels, family evenings and any night the wifi is down.
```

## What's new (500 max)

For the 1.4.0 release (version code 6).

```
• Mafia host mode: one person narrates and keeps the phone, so you stop passing it round every night
• Rotate the host so nobody sits out two games running
• Mafia: the doctor and detective are now optional
• Two new games: Truth or Dare and Heads Up
• Hinglish decks for the prompt games, plus a Bollywood word pack
• One shared player roster across every game
• Add your own prompts to the prompt games
• Haptics, larger text sizes and predictive back gestures
```

## Screenshots

Phone screenshots live in `docs/store/screenshots/` at 1080×1920 (9:16).
They are rendered from the real widgets with the app's fonts, so they can be
regenerated after any UI change:

```bash
flutter test tool/screenshots/store_screenshots_test.dart --update-goldens
```

Suggested order and captions if you frame them:

| File | Caption |
| --- | --- |
| `01-hub.png` | Six games. One phone. Nothing to sign up for. |
| `02-imposter.png` | Imposter: bluff your way through one-word clues. |
| `03-mafia.png` | Mafia: your secret role, for your eyes only. |
| `04-never-have-i-ever.png` | Never Have I Ever: lose a life for every confession. |
| `05-most-likely-to.png` | Most Likely To: everyone points, the most fingers score. |
| `06-truth-or-dare.png` | Truth or Dare: mild or spicy, your call. |
| `07-heads-up.png` | Heads Up: phone on your forehead, clock ticking down. |
| `08-roster.png` | One roster, every game. |

## Other assets

- App icon: `assets/icon/store_icon_512.png` (512×512).
- Feature graphic (1024×500) is managed in Play Console; refresh it if the
  icon or name changes.
- Privacy policy: `docs/privacy-policy.html`, published via GitHub Pages.

## Data safety answers

- Data collected: none.
- Data shared: none.
- Data encrypted in transit: not applicable. The app itself makes no network
  calls; the one-time "rate this app" prompt is shown by Google Play's own
  in-app review flow.
- Users can request deletion: not applicable, nothing is collected.
