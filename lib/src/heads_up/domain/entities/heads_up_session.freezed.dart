// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'heads_up_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HeadsUpSession {

 List<HeadsUpPlayer> get players; Map<String, int> get scores; List<String> get deck; int get deckIndex; int get turnsPlayed; int get roundCount;
/// Create a copy of HeadsUpSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeadsUpSessionCopyWith<HeadsUpSession> get copyWith => _$HeadsUpSessionCopyWithImpl<HeadsUpSession>(this as HeadsUpSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeadsUpSession&&const DeepCollectionEquality().equals(other.players, players)&&const DeepCollectionEquality().equals(other.scores, scores)&&const DeepCollectionEquality().equals(other.deck, deck)&&(identical(other.deckIndex, deckIndex) || other.deckIndex == deckIndex)&&(identical(other.turnsPlayed, turnsPlayed) || other.turnsPlayed == turnsPlayed)&&(identical(other.roundCount, roundCount) || other.roundCount == roundCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(players),const DeepCollectionEquality().hash(scores),const DeepCollectionEquality().hash(deck),deckIndex,turnsPlayed,roundCount);

@override
String toString() {
  return 'HeadsUpSession(players: $players, scores: $scores, deck: $deck, deckIndex: $deckIndex, turnsPlayed: $turnsPlayed, roundCount: $roundCount)';
}


}

/// @nodoc
abstract mixin class $HeadsUpSessionCopyWith<$Res>  {
  factory $HeadsUpSessionCopyWith(HeadsUpSession value, $Res Function(HeadsUpSession) _then) = _$HeadsUpSessionCopyWithImpl;
@useResult
$Res call({
 List<HeadsUpPlayer> players, Map<String, int> scores, List<String> deck, int deckIndex, int turnsPlayed, int roundCount
});




}
/// @nodoc
class _$HeadsUpSessionCopyWithImpl<$Res>
    implements $HeadsUpSessionCopyWith<$Res> {
  _$HeadsUpSessionCopyWithImpl(this._self, this._then);

  final HeadsUpSession _self;
  final $Res Function(HeadsUpSession) _then;

/// Create a copy of HeadsUpSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? players = null,Object? scores = null,Object? deck = null,Object? deckIndex = null,Object? turnsPlayed = null,Object? roundCount = null,}) {
  return _then(_self.copyWith(
players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<HeadsUpPlayer>,scores: null == scores ? _self.scores : scores // ignore: cast_nullable_to_non_nullable
as Map<String, int>,deck: null == deck ? _self.deck : deck // ignore: cast_nullable_to_non_nullable
as List<String>,deckIndex: null == deckIndex ? _self.deckIndex : deckIndex // ignore: cast_nullable_to_non_nullable
as int,turnsPlayed: null == turnsPlayed ? _self.turnsPlayed : turnsPlayed // ignore: cast_nullable_to_non_nullable
as int,roundCount: null == roundCount ? _self.roundCount : roundCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HeadsUpSession].
extension HeadsUpSessionPatterns on HeadsUpSession {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HeadsUpSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HeadsUpSession() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HeadsUpSession value)  $default,){
final _that = this;
switch (_that) {
case _HeadsUpSession():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HeadsUpSession value)?  $default,){
final _that = this;
switch (_that) {
case _HeadsUpSession() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<HeadsUpPlayer> players,  Map<String, int> scores,  List<String> deck,  int deckIndex,  int turnsPlayed,  int roundCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HeadsUpSession() when $default != null:
return $default(_that.players,_that.scores,_that.deck,_that.deckIndex,_that.turnsPlayed,_that.roundCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<HeadsUpPlayer> players,  Map<String, int> scores,  List<String> deck,  int deckIndex,  int turnsPlayed,  int roundCount)  $default,) {final _that = this;
switch (_that) {
case _HeadsUpSession():
return $default(_that.players,_that.scores,_that.deck,_that.deckIndex,_that.turnsPlayed,_that.roundCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<HeadsUpPlayer> players,  Map<String, int> scores,  List<String> deck,  int deckIndex,  int turnsPlayed,  int roundCount)?  $default,) {final _that = this;
switch (_that) {
case _HeadsUpSession() when $default != null:
return $default(_that.players,_that.scores,_that.deck,_that.deckIndex,_that.turnsPlayed,_that.roundCount);case _:
  return null;

}
}

}

/// @nodoc


class _HeadsUpSession extends HeadsUpSession {
  const _HeadsUpSession({required final  List<HeadsUpPlayer> players, required final  Map<String, int> scores, required final  List<String> deck, required this.deckIndex, required this.turnsPlayed, required this.roundCount}): _players = players,_scores = scores,_deck = deck,super._();
  

 final  List<HeadsUpPlayer> _players;
@override List<HeadsUpPlayer> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

 final  Map<String, int> _scores;
@override Map<String, int> get scores {
  if (_scores is EqualUnmodifiableMapView) return _scores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_scores);
}

 final  List<String> _deck;
@override List<String> get deck {
  if (_deck is EqualUnmodifiableListView) return _deck;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deck);
}

@override final  int deckIndex;
@override final  int turnsPlayed;
@override final  int roundCount;

/// Create a copy of HeadsUpSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeadsUpSessionCopyWith<_HeadsUpSession> get copyWith => __$HeadsUpSessionCopyWithImpl<_HeadsUpSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HeadsUpSession&&const DeepCollectionEquality().equals(other._players, _players)&&const DeepCollectionEquality().equals(other._scores, _scores)&&const DeepCollectionEquality().equals(other._deck, _deck)&&(identical(other.deckIndex, deckIndex) || other.deckIndex == deckIndex)&&(identical(other.turnsPlayed, turnsPlayed) || other.turnsPlayed == turnsPlayed)&&(identical(other.roundCount, roundCount) || other.roundCount == roundCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_players),const DeepCollectionEquality().hash(_scores),const DeepCollectionEquality().hash(_deck),deckIndex,turnsPlayed,roundCount);

@override
String toString() {
  return 'HeadsUpSession(players: $players, scores: $scores, deck: $deck, deckIndex: $deckIndex, turnsPlayed: $turnsPlayed, roundCount: $roundCount)';
}


}

/// @nodoc
abstract mixin class _$HeadsUpSessionCopyWith<$Res> implements $HeadsUpSessionCopyWith<$Res> {
  factory _$HeadsUpSessionCopyWith(_HeadsUpSession value, $Res Function(_HeadsUpSession) _then) = __$HeadsUpSessionCopyWithImpl;
@override @useResult
$Res call({
 List<HeadsUpPlayer> players, Map<String, int> scores, List<String> deck, int deckIndex, int turnsPlayed, int roundCount
});




}
/// @nodoc
class __$HeadsUpSessionCopyWithImpl<$Res>
    implements _$HeadsUpSessionCopyWith<$Res> {
  __$HeadsUpSessionCopyWithImpl(this._self, this._then);

  final _HeadsUpSession _self;
  final $Res Function(_HeadsUpSession) _then;

/// Create a copy of HeadsUpSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? players = null,Object? scores = null,Object? deck = null,Object? deckIndex = null,Object? turnsPlayed = null,Object? roundCount = null,}) {
  return _then(_HeadsUpSession(
players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<HeadsUpPlayer>,scores: null == scores ? _self._scores : scores // ignore: cast_nullable_to_non_nullable
as Map<String, int>,deck: null == deck ? _self._deck : deck // ignore: cast_nullable_to_non_nullable
as List<String>,deckIndex: null == deckIndex ? _self.deckIndex : deckIndex // ignore: cast_nullable_to_non_nullable
as int,turnsPlayed: null == turnsPlayed ? _self.turnsPlayed : turnsPlayed // ignore: cast_nullable_to_non_nullable
as int,roundCount: null == roundCount ? _self.roundCount : roundCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
