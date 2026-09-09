/// A countdown clock: emits the seconds remaining, once per second, ending
/// at 0. Abstracted so the bloc's timing is testable with a hand-driven
/// stream — a named seam, not a bare function type, so it can be registered
/// and swapped in DI like every other dependency.
// ignore: one_member_abstracts
abstract interface class HeadsUpTicker {
  Stream<int> tick({required int seconds});
}

/// The real clock.
class PeriodicHeadsUpTicker implements HeadsUpTicker {
  const PeriodicHeadsUpTicker();

  @override
  Stream<int> tick({required int seconds}) => Stream.periodic(
    const Duration(seconds: 1),
    (elapsed) => seconds - elapsed - 1,
  ).take(seconds);
}
