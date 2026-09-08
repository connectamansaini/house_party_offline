// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'most_likely_to_setup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MostLikelyToSetup {

 List<MostLikelyToPlayer> get players; MostLikelyToConfig get config;
/// Create a copy of MostLikelyToSetup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MostLikelyToSetupCopyWith<MostLikelyToSetup> get copyWith => _$MostLikelyToSetupCopyWithImpl<MostLikelyToSetup>(this as MostLikelyToSetup, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MostLikelyToSetup&&const DeepCollectionEquality().equals(other.players, players)&&(identical(other.config, config) || other.config == config));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(players),config);

@override
String toString() {
  return 'MostLikelyToSetup(players: $players, config: $config)';
}


}

/// @nodoc
abstract mixin class $MostLikelyToSetupCopyWith<$Res>  {
  factory $MostLikelyToSetupCopyWith(MostLikelyToSetup value, $Res Function(MostLikelyToSetup) _then) = _$MostLikelyToSetupCopyWithImpl;
@useResult
$Res call({
 List<MostLikelyToPlayer> players, MostLikelyToConfig config
});


$MostLikelyToConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$MostLikelyToSetupCopyWithImpl<$Res>
    implements $MostLikelyToSetupCopyWith<$Res> {
  _$MostLikelyToSetupCopyWithImpl(this._self, this._then);

  final MostLikelyToSetup _self;
  final $Res Function(MostLikelyToSetup) _then;

/// Create a copy of MostLikelyToSetup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? players = null,Object? config = null,}) {
  return _then(_self.copyWith(
players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<MostLikelyToPlayer>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as MostLikelyToConfig,
  ));
}
/// Create a copy of MostLikelyToSetup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MostLikelyToConfigCopyWith<$Res> get config {
  
  return $MostLikelyToConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}


/// Adds pattern-matching-related methods to [MostLikelyToSetup].
extension MostLikelyToSetupPatterns on MostLikelyToSetup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MostLikelyToSetup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MostLikelyToSetup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MostLikelyToSetup value)  $default,){
final _that = this;
switch (_that) {
case _MostLikelyToSetup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MostLikelyToSetup value)?  $default,){
final _that = this;
switch (_that) {
case _MostLikelyToSetup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MostLikelyToPlayer> players,  MostLikelyToConfig config)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MostLikelyToSetup() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MostLikelyToPlayer> players,  MostLikelyToConfig config)  $default,) {final _that = this;
switch (_that) {
case _MostLikelyToSetup():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MostLikelyToPlayer> players,  MostLikelyToConfig config)?  $default,) {final _that = this;
switch (_that) {
case _MostLikelyToSetup() when $default != null:
return $default(_that.players,_that.config);case _:
  return null;

}
}

}

/// @nodoc


class _MostLikelyToSetup implements MostLikelyToSetup {
  const _MostLikelyToSetup({required final  List<MostLikelyToPlayer> players, required this.config}): _players = players;
  

 final  List<MostLikelyToPlayer> _players;
@override List<MostLikelyToPlayer> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

@override final  MostLikelyToConfig config;

/// Create a copy of MostLikelyToSetup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MostLikelyToSetupCopyWith<_MostLikelyToSetup> get copyWith => __$MostLikelyToSetupCopyWithImpl<_MostLikelyToSetup>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MostLikelyToSetup&&const DeepCollectionEquality().equals(other._players, _players)&&(identical(other.config, config) || other.config == config));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_players),config);

@override
String toString() {
  return 'MostLikelyToSetup(players: $players, config: $config)';
}


}

/// @nodoc
abstract mixin class _$MostLikelyToSetupCopyWith<$Res> implements $MostLikelyToSetupCopyWith<$Res> {
  factory _$MostLikelyToSetupCopyWith(_MostLikelyToSetup value, $Res Function(_MostLikelyToSetup) _then) = __$MostLikelyToSetupCopyWithImpl;
@override @useResult
$Res call({
 List<MostLikelyToPlayer> players, MostLikelyToConfig config
});


@override $MostLikelyToConfigCopyWith<$Res> get config;

}
/// @nodoc
class __$MostLikelyToSetupCopyWithImpl<$Res>
    implements _$MostLikelyToSetupCopyWith<$Res> {
  __$MostLikelyToSetupCopyWithImpl(this._self, this._then);

  final _MostLikelyToSetup _self;
  final $Res Function(_MostLikelyToSetup) _then;

/// Create a copy of MostLikelyToSetup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? players = null,Object? config = null,}) {
  return _then(_MostLikelyToSetup(
players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<MostLikelyToPlayer>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as MostLikelyToConfig,
  ));
}

/// Create a copy of MostLikelyToSetup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MostLikelyToConfigCopyWith<$Res> get config {
  
  return $MostLikelyToConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

// dart format on
