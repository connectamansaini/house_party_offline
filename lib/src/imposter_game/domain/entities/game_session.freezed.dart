// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameSession {

 List<Player> get players; GameConfig get config; int get roundNumber;
/// Create a copy of GameSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameSessionCopyWith<GameSession> get copyWith => _$GameSessionCopyWithImpl<GameSession>(this as GameSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameSession&&const DeepCollectionEquality().equals(other.players, players)&&(identical(other.config, config) || other.config == config)&&(identical(other.roundNumber, roundNumber) || other.roundNumber == roundNumber));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(players),config,roundNumber);

@override
String toString() {
  return 'GameSession(players: $players, config: $config, roundNumber: $roundNumber)';
}


}

/// @nodoc
abstract mixin class $GameSessionCopyWith<$Res>  {
  factory $GameSessionCopyWith(GameSession value, $Res Function(GameSession) _then) = _$GameSessionCopyWithImpl;
@useResult
$Res call({
 List<Player> players, GameConfig config, int roundNumber
});


$GameConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$GameSessionCopyWithImpl<$Res>
    implements $GameSessionCopyWith<$Res> {
  _$GameSessionCopyWithImpl(this._self, this._then);

  final GameSession _self;
  final $Res Function(GameSession) _then;

/// Create a copy of GameSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? players = null,Object? config = null,Object? roundNumber = null,}) {
  return _then(_self.copyWith(
players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as GameConfig,roundNumber: null == roundNumber ? _self.roundNumber : roundNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of GameSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameConfigCopyWith<$Res> get config {
  
  return $GameConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameSession].
extension GameSessionPatterns on GameSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameSession value)  $default,){
final _that = this;
switch (_that) {
case _GameSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameSession value)?  $default,){
final _that = this;
switch (_that) {
case _GameSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Player> players,  GameConfig config,  int roundNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameSession() when $default != null:
return $default(_that.players,_that.config,_that.roundNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Player> players,  GameConfig config,  int roundNumber)  $default,) {final _that = this;
switch (_that) {
case _GameSession():
return $default(_that.players,_that.config,_that.roundNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Player> players,  GameConfig config,  int roundNumber)?  $default,) {final _that = this;
switch (_that) {
case _GameSession() when $default != null:
return $default(_that.players,_that.config,_that.roundNumber);case _:
  return null;

}
}

}

/// @nodoc


class _GameSession extends GameSession {
  const _GameSession({required final  List<Player> players, required this.config, this.roundNumber = 1}): _players = players,super._();
  

 final  List<Player> _players;
@override List<Player> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

@override final  GameConfig config;
@override@JsonKey() final  int roundNumber;

/// Create a copy of GameSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameSessionCopyWith<_GameSession> get copyWith => __$GameSessionCopyWithImpl<_GameSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameSession&&const DeepCollectionEquality().equals(other._players, _players)&&(identical(other.config, config) || other.config == config)&&(identical(other.roundNumber, roundNumber) || other.roundNumber == roundNumber));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_players),config,roundNumber);

@override
String toString() {
  return 'GameSession(players: $players, config: $config, roundNumber: $roundNumber)';
}


}

/// @nodoc
abstract mixin class _$GameSessionCopyWith<$Res> implements $GameSessionCopyWith<$Res> {
  factory _$GameSessionCopyWith(_GameSession value, $Res Function(_GameSession) _then) = __$GameSessionCopyWithImpl;
@override @useResult
$Res call({
 List<Player> players, GameConfig config, int roundNumber
});


@override $GameConfigCopyWith<$Res> get config;

}
/// @nodoc
class __$GameSessionCopyWithImpl<$Res>
    implements _$GameSessionCopyWith<$Res> {
  __$GameSessionCopyWithImpl(this._self, this._then);

  final _GameSession _self;
  final $Res Function(_GameSession) _then;

/// Create a copy of GameSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? players = null,Object? config = null,Object? roundNumber = null,}) {
  return _then(_GameSession(
players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as GameConfig,roundNumber: null == roundNumber ? _self.roundNumber : roundNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of GameSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameConfigCopyWith<$Res> get config {
  
  return $GameConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

// dart format on
