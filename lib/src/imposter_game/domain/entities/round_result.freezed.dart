// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'round_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoundResult {

 WinningSide get winningSide;/// The player the group voted out this round.
 String get votedOutId;/// True only when a caught imposter guessed the secret word to steal the
/// win.
 bool get imposterGuessedRight;/// Points to add to each player's cumulative score (0 for the losing
/// side).
 Map<String, int> get scoreDeltas;
/// Create a copy of RoundResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoundResultCopyWith<RoundResult> get copyWith => _$RoundResultCopyWithImpl<RoundResult>(this as RoundResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoundResult&&(identical(other.winningSide, winningSide) || other.winningSide == winningSide)&&(identical(other.votedOutId, votedOutId) || other.votedOutId == votedOutId)&&(identical(other.imposterGuessedRight, imposterGuessedRight) || other.imposterGuessedRight == imposterGuessedRight)&&const DeepCollectionEquality().equals(other.scoreDeltas, scoreDeltas));
}


@override
int get hashCode => Object.hash(runtimeType,winningSide,votedOutId,imposterGuessedRight,const DeepCollectionEquality().hash(scoreDeltas));

@override
String toString() {
  return 'RoundResult(winningSide: $winningSide, votedOutId: $votedOutId, imposterGuessedRight: $imposterGuessedRight, scoreDeltas: $scoreDeltas)';
}


}

/// @nodoc
abstract mixin class $RoundResultCopyWith<$Res>  {
  factory $RoundResultCopyWith(RoundResult value, $Res Function(RoundResult) _then) = _$RoundResultCopyWithImpl;
@useResult
$Res call({
 WinningSide winningSide, String votedOutId, bool imposterGuessedRight, Map<String, int> scoreDeltas
});




}
/// @nodoc
class _$RoundResultCopyWithImpl<$Res>
    implements $RoundResultCopyWith<$Res> {
  _$RoundResultCopyWithImpl(this._self, this._then);

  final RoundResult _self;
  final $Res Function(RoundResult) _then;

/// Create a copy of RoundResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? winningSide = null,Object? votedOutId = null,Object? imposterGuessedRight = null,Object? scoreDeltas = null,}) {
  return _then(_self.copyWith(
winningSide: null == winningSide ? _self.winningSide : winningSide // ignore: cast_nullable_to_non_nullable
as WinningSide,votedOutId: null == votedOutId ? _self.votedOutId : votedOutId // ignore: cast_nullable_to_non_nullable
as String,imposterGuessedRight: null == imposterGuessedRight ? _self.imposterGuessedRight : imposterGuessedRight // ignore: cast_nullable_to_non_nullable
as bool,scoreDeltas: null == scoreDeltas ? _self.scoreDeltas : scoreDeltas // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [RoundResult].
extension RoundResultPatterns on RoundResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoundResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoundResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoundResult value)  $default,){
final _that = this;
switch (_that) {
case _RoundResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoundResult value)?  $default,){
final _that = this;
switch (_that) {
case _RoundResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WinningSide winningSide,  String votedOutId,  bool imposterGuessedRight,  Map<String, int> scoreDeltas)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoundResult() when $default != null:
return $default(_that.winningSide,_that.votedOutId,_that.imposterGuessedRight,_that.scoreDeltas);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WinningSide winningSide,  String votedOutId,  bool imposterGuessedRight,  Map<String, int> scoreDeltas)  $default,) {final _that = this;
switch (_that) {
case _RoundResult():
return $default(_that.winningSide,_that.votedOutId,_that.imposterGuessedRight,_that.scoreDeltas);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WinningSide winningSide,  String votedOutId,  bool imposterGuessedRight,  Map<String, int> scoreDeltas)?  $default,) {final _that = this;
switch (_that) {
case _RoundResult() when $default != null:
return $default(_that.winningSide,_that.votedOutId,_that.imposterGuessedRight,_that.scoreDeltas);case _:
  return null;

}
}

}

/// @nodoc


class _RoundResult implements RoundResult {
  const _RoundResult({required this.winningSide, required this.votedOutId, required this.imposterGuessedRight, required final  Map<String, int> scoreDeltas}): _scoreDeltas = scoreDeltas;
  

@override final  WinningSide winningSide;
/// The player the group voted out this round.
@override final  String votedOutId;
/// True only when a caught imposter guessed the secret word to steal the
/// win.
@override final  bool imposterGuessedRight;
/// Points to add to each player's cumulative score (0 for the losing
/// side).
 final  Map<String, int> _scoreDeltas;
/// Points to add to each player's cumulative score (0 for the losing
/// side).
@override Map<String, int> get scoreDeltas {
  if (_scoreDeltas is EqualUnmodifiableMapView) return _scoreDeltas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_scoreDeltas);
}


/// Create a copy of RoundResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoundResultCopyWith<_RoundResult> get copyWith => __$RoundResultCopyWithImpl<_RoundResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoundResult&&(identical(other.winningSide, winningSide) || other.winningSide == winningSide)&&(identical(other.votedOutId, votedOutId) || other.votedOutId == votedOutId)&&(identical(other.imposterGuessedRight, imposterGuessedRight) || other.imposterGuessedRight == imposterGuessedRight)&&const DeepCollectionEquality().equals(other._scoreDeltas, _scoreDeltas));
}


@override
int get hashCode => Object.hash(runtimeType,winningSide,votedOutId,imposterGuessedRight,const DeepCollectionEquality().hash(_scoreDeltas));

@override
String toString() {
  return 'RoundResult(winningSide: $winningSide, votedOutId: $votedOutId, imposterGuessedRight: $imposterGuessedRight, scoreDeltas: $scoreDeltas)';
}


}

/// @nodoc
abstract mixin class _$RoundResultCopyWith<$Res> implements $RoundResultCopyWith<$Res> {
  factory _$RoundResultCopyWith(_RoundResult value, $Res Function(_RoundResult) _then) = __$RoundResultCopyWithImpl;
@override @useResult
$Res call({
 WinningSide winningSide, String votedOutId, bool imposterGuessedRight, Map<String, int> scoreDeltas
});




}
/// @nodoc
class __$RoundResultCopyWithImpl<$Res>
    implements _$RoundResultCopyWith<$Res> {
  __$RoundResultCopyWithImpl(this._self, this._then);

  final _RoundResult _self;
  final $Res Function(_RoundResult) _then;

/// Create a copy of RoundResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? winningSide = null,Object? votedOutId = null,Object? imposterGuessedRight = null,Object? scoreDeltas = null,}) {
  return _then(_RoundResult(
winningSide: null == winningSide ? _self.winningSide : winningSide // ignore: cast_nullable_to_non_nullable
as WinningSide,votedOutId: null == votedOutId ? _self.votedOutId : votedOutId // ignore: cast_nullable_to_non_nullable
as String,imposterGuessedRight: null == imposterGuessedRight ? _self.imposterGuessedRight : imposterGuessedRight // ignore: cast_nullable_to_non_nullable
as bool,scoreDeltas: null == scoreDeltas ? _self._scoreDeltas : scoreDeltas // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

// dart format on
