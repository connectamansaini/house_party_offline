// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'never_have_i_ever_setup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NeverHaveIEverSetup {

 List<NeverHaveIEverPlayer> get players; NeverHaveIEverConfig get config;
/// Create a copy of NeverHaveIEverSetup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NeverHaveIEverSetupCopyWith<NeverHaveIEverSetup> get copyWith => _$NeverHaveIEverSetupCopyWithImpl<NeverHaveIEverSetup>(this as NeverHaveIEverSetup, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NeverHaveIEverSetup&&const DeepCollectionEquality().equals(other.players, players)&&(identical(other.config, config) || other.config == config));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(players),config);

@override
String toString() {
  return 'NeverHaveIEverSetup(players: $players, config: $config)';
}


}

/// @nodoc
abstract mixin class $NeverHaveIEverSetupCopyWith<$Res>  {
  factory $NeverHaveIEverSetupCopyWith(NeverHaveIEverSetup value, $Res Function(NeverHaveIEverSetup) _then) = _$NeverHaveIEverSetupCopyWithImpl;
@useResult
$Res call({
 List<NeverHaveIEverPlayer> players, NeverHaveIEverConfig config
});


$NeverHaveIEverConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$NeverHaveIEverSetupCopyWithImpl<$Res>
    implements $NeverHaveIEverSetupCopyWith<$Res> {
  _$NeverHaveIEverSetupCopyWithImpl(this._self, this._then);

  final NeverHaveIEverSetup _self;
  final $Res Function(NeverHaveIEverSetup) _then;

/// Create a copy of NeverHaveIEverSetup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? players = null,Object? config = null,}) {
  return _then(_self.copyWith(
players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<NeverHaveIEverPlayer>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as NeverHaveIEverConfig,
  ));
}
/// Create a copy of NeverHaveIEverSetup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NeverHaveIEverConfigCopyWith<$Res> get config {
  
  return $NeverHaveIEverConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}


/// Adds pattern-matching-related methods to [NeverHaveIEverSetup].
extension NeverHaveIEverSetupPatterns on NeverHaveIEverSetup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NeverHaveIEverSetup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NeverHaveIEverSetup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NeverHaveIEverSetup value)  $default,){
final _that = this;
switch (_that) {
case _NeverHaveIEverSetup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NeverHaveIEverSetup value)?  $default,){
final _that = this;
switch (_that) {
case _NeverHaveIEverSetup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<NeverHaveIEverPlayer> players,  NeverHaveIEverConfig config)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NeverHaveIEverSetup() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<NeverHaveIEverPlayer> players,  NeverHaveIEverConfig config)  $default,) {final _that = this;
switch (_that) {
case _NeverHaveIEverSetup():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<NeverHaveIEverPlayer> players,  NeverHaveIEverConfig config)?  $default,) {final _that = this;
switch (_that) {
case _NeverHaveIEverSetup() when $default != null:
return $default(_that.players,_that.config);case _:
  return null;

}
}

}

/// @nodoc


class _NeverHaveIEverSetup implements NeverHaveIEverSetup {
  const _NeverHaveIEverSetup({required final  List<NeverHaveIEverPlayer> players, required this.config}): _players = players;
  

 final  List<NeverHaveIEverPlayer> _players;
@override List<NeverHaveIEverPlayer> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

@override final  NeverHaveIEverConfig config;

/// Create a copy of NeverHaveIEverSetup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NeverHaveIEverSetupCopyWith<_NeverHaveIEverSetup> get copyWith => __$NeverHaveIEverSetupCopyWithImpl<_NeverHaveIEverSetup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NeverHaveIEverSetup&&const DeepCollectionEquality().equals(other._players, _players)&&(identical(other.config, config) || other.config == config));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_players),config);

@override
String toString() {
  return 'NeverHaveIEverSetup(players: $players, config: $config)';
}


}

/// @nodoc
abstract mixin class _$NeverHaveIEverSetupCopyWith<$Res> implements $NeverHaveIEverSetupCopyWith<$Res> {
  factory _$NeverHaveIEverSetupCopyWith(_NeverHaveIEverSetup value, $Res Function(_NeverHaveIEverSetup) _then) = __$NeverHaveIEverSetupCopyWithImpl;
@override @useResult
$Res call({
 List<NeverHaveIEverPlayer> players, NeverHaveIEverConfig config
});


@override $NeverHaveIEverConfigCopyWith<$Res> get config;

}
/// @nodoc
class __$NeverHaveIEverSetupCopyWithImpl<$Res>
    implements _$NeverHaveIEverSetupCopyWith<$Res> {
  __$NeverHaveIEverSetupCopyWithImpl(this._self, this._then);

  final _NeverHaveIEverSetup _self;
  final $Res Function(_NeverHaveIEverSetup) _then;

/// Create a copy of NeverHaveIEverSetup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? players = null,Object? config = null,}) {
  return _then(_NeverHaveIEverSetup(
players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<NeverHaveIEverPlayer>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as NeverHaveIEverConfig,
  ));
}

/// Create a copy of NeverHaveIEverSetup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NeverHaveIEverConfigCopyWith<$Res> get config {
  
  return $NeverHaveIEverConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

// dart format on
