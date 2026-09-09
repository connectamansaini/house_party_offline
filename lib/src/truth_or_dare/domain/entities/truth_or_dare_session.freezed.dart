// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'truth_or_dare_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TruthOrDareSession {

 List<TruthOrDarePlayer> get players; Map<String, int> get scores; List<String> get truths; List<String> get dares; int get truthIndex; int get dareIndex; int get turnsPlayed; int get roundCount;
/// Create a copy of TruthOrDareSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TruthOrDareSessionCopyWith<TruthOrDareSession> get copyWith => _$TruthOrDareSessionCopyWithImpl<TruthOrDareSession>(this as TruthOrDareSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TruthOrDareSession&&const DeepCollectionEquality().equals(other.players, players)&&const DeepCollectionEquality().equals(other.scores, scores)&&const DeepCollectionEquality().equals(other.truths, truths)&&const DeepCollectionEquality().equals(other.dares, dares)&&(identical(other.truthIndex, truthIndex) || other.truthIndex == truthIndex)&&(identical(other.dareIndex, dareIndex) || other.dareIndex == dareIndex)&&(identical(other.turnsPlayed, turnsPlayed) || other.turnsPlayed == turnsPlayed)&&(identical(other.roundCount, roundCount) || other.roundCount == roundCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(players),const DeepCollectionEquality().hash(scores),const DeepCollectionEquality().hash(truths),const DeepCollectionEquality().hash(dares),truthIndex,dareIndex,turnsPlayed,roundCount);

@override
String toString() {
  return 'TruthOrDareSession(players: $players, scores: $scores, truths: $truths, dares: $dares, truthIndex: $truthIndex, dareIndex: $dareIndex, turnsPlayed: $turnsPlayed, roundCount: $roundCount)';
}


}

/// @nodoc
abstract mixin class $TruthOrDareSessionCopyWith<$Res>  {
  factory $TruthOrDareSessionCopyWith(TruthOrDareSession value, $Res Function(TruthOrDareSession) _then) = _$TruthOrDareSessionCopyWithImpl;
@useResult
$Res call({
 List<TruthOrDarePlayer> players, Map<String, int> scores, List<String> truths, List<String> dares, int truthIndex, int dareIndex, int turnsPlayed, int roundCount
});




}
/// @nodoc
class _$TruthOrDareSessionCopyWithImpl<$Res>
    implements $TruthOrDareSessionCopyWith<$Res> {
  _$TruthOrDareSessionCopyWithImpl(this._self, this._then);

  final TruthOrDareSession _self;
  final $Res Function(TruthOrDareSession) _then;

/// Create a copy of TruthOrDareSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? players = null,Object? scores = null,Object? truths = null,Object? dares = null,Object? truthIndex = null,Object? dareIndex = null,Object? turnsPlayed = null,Object? roundCount = null,}) {
  return _then(_self.copyWith(
players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<TruthOrDarePlayer>,scores: null == scores ? _self.scores : scores // ignore: cast_nullable_to_non_nullable
as Map<String, int>,truths: null == truths ? _self.truths : truths // ignore: cast_nullable_to_non_nullable
as List<String>,dares: null == dares ? _self.dares : dares // ignore: cast_nullable_to_non_nullable
as List<String>,truthIndex: null == truthIndex ? _self.truthIndex : truthIndex // ignore: cast_nullable_to_non_nullable
as int,dareIndex: null == dareIndex ? _self.dareIndex : dareIndex // ignore: cast_nullable_to_non_nullable
as int,turnsPlayed: null == turnsPlayed ? _self.turnsPlayed : turnsPlayed // ignore: cast_nullable_to_non_nullable
as int,roundCount: null == roundCount ? _self.roundCount : roundCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TruthOrDareSession].
extension TruthOrDareSessionPatterns on TruthOrDareSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TruthOrDareSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TruthOrDareSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TruthOrDareSession value)  $default,){
final _that = this;
switch (_that) {
case _TruthOrDareSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TruthOrDareSession value)?  $default,){
final _that = this;
switch (_that) {
case _TruthOrDareSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TruthOrDarePlayer> players,  Map<String, int> scores,  List<String> truths,  List<String> dares,  int truthIndex,  int dareIndex,  int turnsPlayed,  int roundCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TruthOrDareSession() when $default != null:
return $default(_that.players,_that.scores,_that.truths,_that.dares,_that.truthIndex,_that.dareIndex,_that.turnsPlayed,_that.roundCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TruthOrDarePlayer> players,  Map<String, int> scores,  List<String> truths,  List<String> dares,  int truthIndex,  int dareIndex,  int turnsPlayed,  int roundCount)  $default,) {final _that = this;
switch (_that) {
case _TruthOrDareSession():
return $default(_that.players,_that.scores,_that.truths,_that.dares,_that.truthIndex,_that.dareIndex,_that.turnsPlayed,_that.roundCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TruthOrDarePlayer> players,  Map<String, int> scores,  List<String> truths,  List<String> dares,  int truthIndex,  int dareIndex,  int turnsPlayed,  int roundCount)?  $default,) {final _that = this;
switch (_that) {
case _TruthOrDareSession() when $default != null:
return $default(_that.players,_that.scores,_that.truths,_that.dares,_that.truthIndex,_that.dareIndex,_that.turnsPlayed,_that.roundCount);case _:
  return null;

}
}

}

/// @nodoc


class _TruthOrDareSession extends TruthOrDareSession {
  const _TruthOrDareSession({required final  List<TruthOrDarePlayer> players, required final  Map<String, int> scores, required final  List<String> truths, required final  List<String> dares, required this.truthIndex, required this.dareIndex, required this.turnsPlayed, required this.roundCount}): _players = players,_scores = scores,_truths = truths,_dares = dares,super._();
  

 final  List<TruthOrDarePlayer> _players;
@override List<TruthOrDarePlayer> get players {
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

 final  List<String> _truths;
@override List<String> get truths {
  if (_truths is EqualUnmodifiableListView) return _truths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_truths);
}

 final  List<String> _dares;
@override List<String> get dares {
  if (_dares is EqualUnmodifiableListView) return _dares;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dares);
}

@override final  int truthIndex;
@override final  int dareIndex;
@override final  int turnsPlayed;
@override final  int roundCount;

/// Create a copy of TruthOrDareSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TruthOrDareSessionCopyWith<_TruthOrDareSession> get copyWith => __$TruthOrDareSessionCopyWithImpl<_TruthOrDareSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TruthOrDareSession&&const DeepCollectionEquality().equals(other._players, _players)&&const DeepCollectionEquality().equals(other._scores, _scores)&&const DeepCollectionEquality().equals(other._truths, _truths)&&const DeepCollectionEquality().equals(other._dares, _dares)&&(identical(other.truthIndex, truthIndex) || other.truthIndex == truthIndex)&&(identical(other.dareIndex, dareIndex) || other.dareIndex == dareIndex)&&(identical(other.turnsPlayed, turnsPlayed) || other.turnsPlayed == turnsPlayed)&&(identical(other.roundCount, roundCount) || other.roundCount == roundCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_players),const DeepCollectionEquality().hash(_scores),const DeepCollectionEquality().hash(_truths),const DeepCollectionEquality().hash(_dares),truthIndex,dareIndex,turnsPlayed,roundCount);

@override
String toString() {
  return 'TruthOrDareSession(players: $players, scores: $scores, truths: $truths, dares: $dares, truthIndex: $truthIndex, dareIndex: $dareIndex, turnsPlayed: $turnsPlayed, roundCount: $roundCount)';
}


}

/// @nodoc
abstract mixin class _$TruthOrDareSessionCopyWith<$Res> implements $TruthOrDareSessionCopyWith<$Res> {
  factory _$TruthOrDareSessionCopyWith(_TruthOrDareSession value, $Res Function(_TruthOrDareSession) _then) = __$TruthOrDareSessionCopyWithImpl;
@override @useResult
$Res call({
 List<TruthOrDarePlayer> players, Map<String, int> scores, List<String> truths, List<String> dares, int truthIndex, int dareIndex, int turnsPlayed, int roundCount
});




}
/// @nodoc
class __$TruthOrDareSessionCopyWithImpl<$Res>
    implements _$TruthOrDareSessionCopyWith<$Res> {
  __$TruthOrDareSessionCopyWithImpl(this._self, this._then);

  final _TruthOrDareSession _self;
  final $Res Function(_TruthOrDareSession) _then;

/// Create a copy of TruthOrDareSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? players = null,Object? scores = null,Object? truths = null,Object? dares = null,Object? truthIndex = null,Object? dareIndex = null,Object? turnsPlayed = null,Object? roundCount = null,}) {
  return _then(_TruthOrDareSession(
players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<TruthOrDarePlayer>,scores: null == scores ? _self._scores : scores // ignore: cast_nullable_to_non_nullable
as Map<String, int>,truths: null == truths ? _self._truths : truths // ignore: cast_nullable_to_non_nullable
as List<String>,dares: null == dares ? _self._dares : dares // ignore: cast_nullable_to_non_nullable
as List<String>,truthIndex: null == truthIndex ? _self.truthIndex : truthIndex // ignore: cast_nullable_to_non_nullable
as int,dareIndex: null == dareIndex ? _self.dareIndex : dareIndex // ignore: cast_nullable_to_non_nullable
as int,turnsPlayed: null == turnsPlayed ? _self.turnsPlayed : turnsPlayed // ignore: cast_nullable_to_non_nullable
as int,roundCount: null == roundCount ? _self.roundCount : roundCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
