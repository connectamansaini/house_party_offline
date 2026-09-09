import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/roster/domain/roster_seed.dart';

void main() {
  test('nothing saved yields the numbered defaults up to min', () {
    expect(seedRosterNames(const [], min: 3, max: 12), [
      'Player 1',
      'Player 2',
      'Player 3',
    ]);
  });

  test('saved names are used as-is and padded up to min', () {
    expect(seedRosterNames(const ['Ann'], min: 3, max: 12), [
      'Ann',
      'Player 2',
      'Player 3',
    ]);
  });

  test('more saved names than max are cut to max', () {
    expect(seedRosterNames(const ['A', 'B', 'C', 'D'], min: 2, max: 3), [
      'A',
      'B',
      'C',
    ]);
  });

  test('blank names are dropped before padding', () {
    expect(seedRosterNames(const ['Ann', '  ', 'Bo'], min: 2, max: 12), [
      'Ann',
      'Bo',
    ]);
  });
}
