// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mafia_setup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MafiaSetup {

 List<MafiaPlayer> get players; MafiaConfig get config;
/// Create a copy of MafiaSetup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MafiaSetupCopyWith<MafiaSetup> get copyWith => _$MafiaSetupCopyWithImpl<MafiaSetup>(this as MafiaSetup, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MafiaSetup&&const DeepCollectionEquality().equals(other.players, players)&&(identical(other.config, config) || other.config == config));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(players),config);

@override
String toString() {
  return 'MafiaSetup(players: $players, config: $config)';
}


}

/// @nodoc
abstract mixin class $MafiaSetupCopyWith<$Res>  {
  factory $MafiaSetupCopyWith(MafiaSetup value, $Res Function(MafiaSetup) _then) = _$MafiaSetupCopyWithImpl;
@useResult
$Res call({
 List<MafiaPlayer> players, MafiaConfig config
});


$MafiaConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$MafiaSetupCopyWithImpl<$Res>
    implements $MafiaSetupCopyWith<$Res> {
  _$MafiaSetupCopyWithImpl(this._self, this._then);

  final MafiaSetup _self;
  final $Res Function(MafiaSetup) _then;

/// Create a copy of MafiaSetup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? players = null,Object? config = null,}) {
  return _then(_self.copyWith(
players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<MafiaPlayer>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as MafiaConfig,
  ));
}
/// Create a copy of MafiaSetup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MafiaConfigCopyWith<$Res> get config {
  
  return $MafiaConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}


/// Adds pattern-matching-related methods to [MafiaSetup].
extension MafiaSetupPatterns on MafiaSetup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MafiaSetup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MafiaSetup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MafiaSetup value)  $default,){
final _that = this;
switch (_that) {
case _MafiaSetup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MafiaSetup value)?  $default,){
final _that = this;
switch (_that) {
case _MafiaSetup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MafiaPlayer> players,  MafiaConfig config)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MafiaSetup() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MafiaPlayer> players,  MafiaConfig config)  $default,) {final _that = this;
switch (_that) {
case _MafiaSetup():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MafiaPlayer> players,  MafiaConfig config)?  $default,) {final _that = this;
switch (_that) {
case _MafiaSetup() when $default != null:
return $default(_that.players,_that.config);case _:
  return null;

}
}

}

/// @nodoc


class _MafiaSetup implements MafiaSetup {
  const _MafiaSetup({required final  List<MafiaPlayer> players, required this.config}): _players = players;
  

 final  List<MafiaPlayer> _players;
@override List<MafiaPlayer> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

@override final  MafiaConfig config;

/// Create a copy of MafiaSetup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MafiaSetupCopyWith<_MafiaSetup> get copyWith => __$MafiaSetupCopyWithImpl<_MafiaSetup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MafiaSetup&&const DeepCollectionEquality().equals(other._players, _players)&&(identical(other.config, config) || other.config == config));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_players),config);

@override
String toString() {
  return 'MafiaSetup(players: $players, config: $config)';
}


}

/// @nodoc
abstract mixin class _$MafiaSetupCopyWith<$Res> implements $MafiaSetupCopyWith<$Res> {
  factory _$MafiaSetupCopyWith(_MafiaSetup value, $Res Function(_MafiaSetup) _then) = __$MafiaSetupCopyWithImpl;
@override @useResult
$Res call({
 List<MafiaPlayer> players, MafiaConfig config
});


@override $MafiaConfigCopyWith<$Res> get config;

}
/// @nodoc
class __$MafiaSetupCopyWithImpl<$Res>
    implements _$MafiaSetupCopyWith<$Res> {
  __$MafiaSetupCopyWithImpl(this._self, this._then);

  final _MafiaSetup _self;
  final $Res Function(_MafiaSetup) _then;

/// Create a copy of MafiaSetup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? players = null,Object? config = null,}) {
  return _then(_MafiaSetup(
players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<MafiaPlayer>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as MafiaConfig,
  ));
}

/// Create a copy of MafiaSetup
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
