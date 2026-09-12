import 'package:flutter_test/flutter_test.dart';
import 'package:house_party_offline/src/mafia_setup/domain/host_rotation.dart';

void main() {
  const names = ['Ann', 'Bo', 'Cy'];

  test('the first game starts the rotation at the top of the roster', () {
    expect(nextHostName(names, lastHost: null, rotate: true), 'Ann');
    expect(nextHostName(names, lastHost: null, rotate: false), 'Ann');
  });

  test('rotating moves one seat down', () {
    expect(nextHostName(names, lastHost: 'Ann', rotate: true), 'Bo');
    expect(nextHostName(names, lastHost: 'Bo', rotate: true), 'Cy');
  });

  test('rotating wraps around at the end', () {
    expect(nextHostName(names, lastHost: 'Cy', rotate: true), 'Ann');
  });

  test('not rotating keeps the same narrator', () {
    expect(nextHostName(names, lastHost: 'Bo', rotate: false), 'Bo');
  });

  test('a narrator who has left the roster restarts the rotation', () {
    expect(nextHostName(names, lastHost: 'Zed', rotate: true), 'Ann');
    expect(nextHostName(names, lastHost: 'Zed', rotate: false), 'Ann');
  });

  test('an empty roster has nobody to narrate', () {
    expect(nextHostName([], lastHost: 'Ann', rotate: true), isNull);
  });

  test('one name keeps hosting itself', () {
    expect(nextHostName(['Ann'], lastHost: 'Ann', rotate: true), 'Ann');
  });
}
