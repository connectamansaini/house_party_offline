// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mafia_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MafiaSession {

 List<MafiaPlayer> get players; Map<String, MafiaRole> get roles; Set<String> get aliveIds; MafiaConfig get config; int get nightNumber;
/// Create a copy of MafiaSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MafiaSessionCopyWith<MafiaSession> get copyWith => _$MafiaSessionCopyWithImpl<MafiaSession>(this as MafiaSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MafiaSession&&const DeepCollectionEquality().equals(other.players, players)&&const DeepCollectionEquality().equals(other.roles, roles)&&const DeepCollectionEquality().equals(other.aliveIds, aliveIds)&&(identical(other.config, config) || other.config == config)&&(identical(other.nightNumber, nightNumber) || other.nightNumber == nightNumber));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(players),const DeepCollectionEquality().hash(roles),const DeepCollectionEquality().hash(aliveIds),config,nightNumber);

@override
String toString() {
  return 'MafiaSession(players: $players, roles: $roles, aliveIds: $aliveIds, config: $config, nightNumber: $nightNumber)';
}


}

/// @nodoc
abstract mixin class $MafiaSessionCopyWith<$Res>  {
  factory $MafiaSessionCopyWith(MafiaSession value, $Res Function(MafiaSession) _then) = _$MafiaSessionCopyWithImpl;
@useResult
$Res call({
 List<MafiaPlayer> players, Map<String, MafiaRole> roles, Set<String> aliveIds, MafiaConfig config, int nightNumber
});


$MafiaConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$MafiaSessionCopyWithImpl<$Res>
    implements $MafiaSessionCopyWith<$Res> {
  _$MafiaSessionCopyWithImpl(this._self, this._then);

  final MafiaSession _self;
  final $Res Function(MafiaSession) _then;

/// Create a copy of MafiaSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? players = null,Object? roles = null,Object? aliveIds = null,Object? config = null,Object? nightNumber = null,}) {
  return _then(_self.copyWith(
players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<MafiaPlayer>,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as Map<String, MafiaRole>,aliveIds: null == aliveIds ? _self.aliveIds : aliveIds // ignore: cast_nullable_to_non_nullable
as Set<String>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as MafiaConfig,nightNumber: null == nightNumber ? _self.nightNumber : nightNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of MafiaSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MafiaConfigCopyWith<$Res> get config {
  
  return $MafiaConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}


/// Adds pattern-matching-related methods to [MafiaSession].
extension MafiaSessionPatterns on MafiaSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MafiaSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MafiaSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MafiaSession value)  $default,){
final _that = this;
switch (_that) {
case _MafiaSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MafiaSession value)?  $default,){
final _that = this;
switch (_that) {
case _MafiaSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MafiaPlayer> players,  Map<String, MafiaRole> roles,  Set<String> aliveIds,  MafiaConfig config,  int nightNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MafiaSession() when $default != null:
return $default(_that.players,_that.roles,_that.aliveIds,_that.config,_that.nightNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MafiaPlayer> players,  Map<String, MafiaRole> roles,  Set<String> aliveIds,  MafiaConfig config,  int nightNumber)  $default,) {final _that = this;
switch (_that) {
case _MafiaSession():
return $default(_that.players,_that.roles,_that.aliveIds,_that.config,_that.nightNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MafiaPlayer> players,  Map<String, MafiaRole> roles,  Set<String> aliveIds,  MafiaConfig config,  int nightNumber)?  $default,) {final _that = this;
switch (_that) {
case _MafiaSession() when $default != null:
return $default(_that.players,_that.roles,_that.aliveIds,_that.config,_that.nightNumber);case _:
  return null;

}
}

}

/// @nodoc


class _MafiaSession extends MafiaSession {
  const _MafiaSession({required final  List<MafiaPlayer> players, required final  Map<String, MafiaRole> roles, required final  Set<String> aliveIds, required this.config, this.nightNumber = 1}): _players = players,_roles = roles,_aliveIds = aliveIds,super._();
  

 final  List<MafiaPlayer> _players;
@override List<MafiaPlayer> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

 final  Map<String, MafiaRole> _roles;
@override Map<String, MafiaRole> get roles {
  if (_roles is EqualUnmodifiableMapView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_roles);
}

 final  Set<String> _aliveIds;
@override Set<String> get aliveIds {
  if (_aliveIds is EqualUnmodifiableSetView) return _aliveIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_aliveIds);
}

@override final  MafiaConfig config;
@override@JsonKey() final  int nightNumber;

/// Create a copy of MafiaSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MafiaSessionCopyWith<_MafiaSession> get copyWith => __$MafiaSessionCopyWithImpl<_MafiaSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MafiaSession&&const DeepCollectionEquality().equals(other._players, _players)&&const DeepCollectionEquality().equals(other._roles, _roles)&&const DeepCollectionEquality().equals(other._aliveIds, _aliveIds)&&(identical(other.config, config) || other.config == config)&&(identical(other.nightNumber, nightNumber) || other.nightNumber == nightNumber));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_players),const DeepCollectionEquality().hash(_roles),const DeepCollectionEquality().hash(_aliveIds),config,nightNumber);

@override
String toString() {
  return 'MafiaSession(players: $players, roles: $roles, aliveIds: $aliveIds, config: $config, nightNumber: $nightNumber)';
}


}

/// @nodoc
abstract mixin class _$MafiaSessionCopyWith<$Res> implements $MafiaSessionCopyWith<$Res> {
  factory _$MafiaSessionCopyWith(_MafiaSession value, $Res Function(_MafiaSession) _then) = __$MafiaSessionCopyWithImpl;
@override @useResult
$Res call({
 List<MafiaPlayer> players, Map<String, MafiaRole> roles, Set<String> aliveIds, MafiaConfig config, int nightNumber
});


@override $MafiaConfigCopyWith<$Res> get config;

}
/// @nodoc
class __$MafiaSessionCopyWithImpl<$Res>
    implements _$MafiaSessionCopyWith<$Res> {
  __$MafiaSessionCopyWithImpl(this._self, this._then);

  final _MafiaSession _self;
  final $Res Function(_MafiaSession) _then;

/// Create a copy of MafiaSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? players = null,Object? roles = null,Object? aliveIds = null,Object? config = null,Object? nightNumber = null,}) {
  return _then(_MafiaSession(
players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<MafiaPlayer>,roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as Map<String, MafiaRole>,aliveIds: null == aliveIds ? _self._aliveIds : aliveIds // ignore: cast_nullable_to_non_nullable
as Set<String>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as MafiaConfig,nightNumber: null == nightNumber ? _self.nightNumber : nightNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of MafiaSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MafiaConfigCopyWith<$Res> get config {
  
  return $MafiaConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

// dart format on
