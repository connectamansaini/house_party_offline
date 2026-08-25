// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_setup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameSetup {

 List<Player> get players; GameConfig get config;
/// Create a copy of GameSetup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameSetupCopyWith<GameSetup> get copyWith => _$GameSetupCopyWithImpl<GameSetup>(this as GameSetup, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameSetup&&const DeepCollectionEquality().equals(other.players, players)&&(identical(other.config, config) || other.config == config));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(players),config);

@override
String toString() {
  return 'GameSetup(players: $players, config: $config)';
}


}

/// @nodoc
abstract mixin class $GameSetupCopyWith<$Res>  {
  factory $GameSetupCopyWith(GameSetup value, $Res Function(GameSetup) _then) = _$GameSetupCopyWithImpl;
@useResult
$Res call({
 List<Player> players, GameConfig config
});


$GameConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$GameSetupCopyWithImpl<$Res>
    implements $GameSetupCopyWith<$Res> {
  _$GameSetupCopyWithImpl(this._self, this._then);

  final GameSetup _self;
  final $Res Function(GameSetup) _then;

/// Create a copy of GameSetup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? players = null,Object? config = null,}) {
  return _then(_self.copyWith(
players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as GameConfig,
  ));
}
/// Create a copy of GameSetup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameConfigCopyWith<$Res> get config {
  
  return $GameConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameSetup].
extension GameSetupPatterns on GameSetup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameSetup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameSetup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameSetup value)  $default,){
final _that = this;
switch (_that) {
case _GameSetup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameSetup value)?  $default,){
final _that = this;
switch (_that) {
case _GameSetup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Player> players,  GameConfig config)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameSetup() when $default != null:
return $default(_that.players,_that.config);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Player> players,  GameConfig config)  $default,) {final _that = this;
switch (_that) {
case _GameSetup():
return $default(_that.players,_that.config);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Player> players,  GameConfig config)?  $default,) {final _that = this;
switch (_that) {
case _GameSetup() when $default != null:
return $default(_that.players,_that.config);case _:
  return null;

}
}

}

/// @nodoc


class _GameSetup implements GameSetup {
  const _GameSetup({required final  List<Player> players, required this.config}): _players = players;
  

 final  List<Player> _players;
@override List<Player> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

@override final  GameConfig config;

/// Create a copy of GameSetup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameSetupCopyWith<_GameSetup> get copyWith => __$GameSetupCopyWithImpl<_GameSetup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameSetup&&const DeepCollectionEquality().equals(other._players, _players)&&(identical(other.config, config) || other.config == config));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_players),config);

@override
String toString() {
  return 'GameSetup(players: $players, config: $config)';
}


}

/// @nodoc
abstract mixin class _$GameSetupCopyWith<$Res> implements $GameSetupCopyWith<$Res> {
  factory _$GameSetupCopyWith(_GameSetup value, $Res Function(_GameSetup) _then) = __$GameSetupCopyWithImpl;
@override @useResult
$Res call({
 List<Player> players, GameConfig config
});


@override $GameConfigCopyWith<$Res> get config;

}
/// @nodoc
class __$GameSetupCopyWithImpl<$Res>
    implements _$GameSetupCopyWith<$Res> {
  __$GameSetupCopyWithImpl(this._self, this._then);

  final _GameSetup _self;
  final $Res Function(_GameSetup) _then;

/// Create a copy of GameSetup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? players = null,Object? config = null,}) {
  return _then(_GameSetup(
players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as GameConfig,
  ));
}

/// Create a copy of GameSetup
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
