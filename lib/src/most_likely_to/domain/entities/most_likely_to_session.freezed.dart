// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'most_likely_to_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MostLikelyToSession {

 List<MostLikelyToPlayer> get players; Map<String, int> get scores; List<String> get deck; int get promptIndex; int get totalRounds;
/// Create a copy of MostLikelyToSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MostLikelyToSessionCopyWith<MostLikelyToSession> get copyWith => _$MostLikelyToSessionCopyWithImpl<MostLikelyToSession>(this as MostLikelyToSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MostLikelyToSession&&const DeepCollectionEquality().equals(other.players, players)&&const DeepCollectionEquality().equals(other.scores, scores)&&const DeepCollectionEquality().equals(other.deck, deck)&&(identical(other.promptIndex, promptIndex) || other.promptIndex == promptIndex)&&(identical(other.totalRounds, totalRounds) || other.totalRounds == totalRounds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(players),const DeepCollectionEquality().hash(scores),const DeepCollectionEquality().hash(deck),promptIndex,totalRounds);

@override
String toString() {
  return 'MostLikelyToSession(players: $players, scores: $scores, deck: $deck, promptIndex: $promptIndex, totalRounds: $totalRounds)';
}


}

/// @nodoc
abstract mixin class $MostLikelyToSessionCopyWith<$Res>  {
  factory $MostLikelyToSessionCopyWith(MostLikelyToSession value, $Res Function(MostLikelyToSession) _then) = _$MostLikelyToSessionCopyWithImpl;
@useResult
$Res call({
 List<MostLikelyToPlayer> players, Map<String, int> scores, List<String> deck, int promptIndex, int totalRounds
});




}
/// @nodoc
class _$MostLikelyToSessionCopyWithImpl<$Res>
    implements $MostLikelyToSessionCopyWith<$Res> {
  _$MostLikelyToSessionCopyWithImpl(this._self, this._then);

  final MostLikelyToSession _self;
  final $Res Function(MostLikelyToSession) _then;

/// Create a copy of MostLikelyToSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? players = null,Object? scores = null,Object? deck = null,Object? promptIndex = null,Object? totalRounds = null,}) {
  return _then(_self.copyWith(
players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<MostLikelyToPlayer>,scores: null == scores ? _self.scores : scores // ignore: cast_nullable_to_non_nullable
as Map<String, int>,deck: null == deck ? _self.deck : deck // ignore: cast_nullable_to_non_nullable
as List<String>,promptIndex: null == promptIndex ? _self.promptIndex : promptIndex // ignore: cast_nullable_to_non_nullable
as int,totalRounds: null == totalRounds ? _self.totalRounds : totalRounds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MostLikelyToSession].
extension MostLikelyToSessionPatterns on MostLikelyToSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MostLikelyToSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MostLikelyToSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MostLikelyToSession value)  $default,){
final _that = this;
switch (_that) {
case _MostLikelyToSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MostLikelyToSession value)?  $default,){
final _that = this;
switch (_that) {
case _MostLikelyToSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MostLikelyToPlayer> players,  Map<String, int> scores,  List<String> deck,  int promptIndex,  int totalRounds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MostLikelyToSession() when $default != null:
return $default(_that.players,_that.scores,_that.deck,_that.promptIndex,_that.totalRounds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MostLikelyToPlayer> players,  Map<String, int> scores,  List<String> deck,  int promptIndex,  int totalRounds)  $default,) {final _that = this;
switch (_that) {
case _MostLikelyToSession():
return $default(_that.players,_that.scores,_that.deck,_that.promptIndex,_that.totalRounds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MostLikelyToPlayer> players,  Map<String, int> scores,  List<String> deck,  int promptIndex,  int totalRounds)?  $default,) {final _that = this;
switch (_that) {
case _MostLikelyToSession() when $default != null:
return $default(_that.players,_that.scores,_that.deck,_that.promptIndex,_that.totalRounds);case _:
  return null;

}
}

}

/// @nodoc


class _MostLikelyToSession extends MostLikelyToSession {
  const _MostLikelyToSession({required final  List<MostLikelyToPlayer> players, required final  Map<String, int> scores, required final  List<String> deck, required this.promptIndex, required this.totalRounds}): _players = players,_scores = scores,_deck = deck,super._();
  

 final  List<MostLikelyToPlayer> _players;
@override List<MostLikelyToPlayer> get players {
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

@override final  int promptIndex;
@override final  int totalRounds;

/// Create a copy of MostLikelyToSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MostLikelyToSessionCopyWith<_MostLikelyToSession> get copyWith => __$MostLikelyToSessionCopyWithImpl<_MostLikelyToSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MostLikelyToSession&&const DeepCollectionEquality().equals(other._players, _players)&&const DeepCollectionEquality().equals(other._scores, _scores)&&const DeepCollectionEquality().equals(other._deck, _deck)&&(identical(other.promptIndex, promptIndex) || other.promptIndex == promptIndex)&&(identical(other.totalRounds, totalRounds) || other.totalRounds == totalRounds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_players),const DeepCollectionEquality().hash(_scores),const DeepCollectionEquality().hash(_deck),promptIndex,totalRounds);

@override
String toString() {
  return 'MostLikelyToSession(players: $players, scores: $scores, deck: $deck, promptIndex: $promptIndex, totalRounds: $totalRounds)';
}


}

/// @nodoc
abstract mixin class _$MostLikelyToSessionCopyWith<$Res> implements $MostLikelyToSessionCopyWith<$Res> {
  factory _$MostLikelyToSessionCopyWith(_MostLikelyToSession value, $Res Function(_MostLikelyToSession) _then) = __$MostLikelyToSessionCopyWithImpl;
@override @useResult
$Res call({
 List<MostLikelyToPlayer> players, Map<String, int> scores, List<String> deck, int promptIndex, int totalRounds
});




}
/// @nodoc
class __$MostLikelyToSessionCopyWithImpl<$Res>
    implements _$MostLikelyToSessionCopyWith<$Res> {
  __$MostLikelyToSessionCopyWithImpl(this._self, this._then);

  final _MostLikelyToSession _self;
  final $Res Function(_MostLikelyToSession) _then;

/// Create a copy of MostLikelyToSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? players = null,Object? scores = null,Object? deck = null,Object? promptIndex = null,Object? totalRounds = null,}) {
  return _then(_MostLikelyToSession(
players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<MostLikelyToPlayer>,scores: null == scores ? _self._scores : scores // ignore: cast_nullable_to_non_nullable
as Map<String, int>,deck: null == deck ? _self._deck : deck // ignore: cast_nullable_to_non_nullable
as List<String>,promptIndex: null == promptIndex ? _self.promptIndex : promptIndex // ignore: cast_nullable_to_non_nullable
as int,totalRounds: null == totalRounds ? _self.totalRounds : totalRounds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
