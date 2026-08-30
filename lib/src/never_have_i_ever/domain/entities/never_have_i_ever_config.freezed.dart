// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'never_have_i_ever_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NeverHaveIEverConfig {

/// How many prompts a player can match before they're out.
 int get livesPerPlayer;
/// Create a copy of NeverHaveIEverConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NeverHaveIEverConfigCopyWith<NeverHaveIEverConfig> get copyWith => _$NeverHaveIEverConfigCopyWithImpl<NeverHaveIEverConfig>(this as NeverHaveIEverConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NeverHaveIEverConfig&&(identical(other.livesPerPlayer, livesPerPlayer) || other.livesPerPlayer == livesPerPlayer));
}


@override
int get hashCode => Object.hash(runtimeType,livesPerPlayer);

@override
String toString() {
  return 'NeverHaveIEverConfig(livesPerPlayer: $livesPerPlayer)';
}


}

/// @nodoc
abstract mixin class $NeverHaveIEverConfigCopyWith<$Res>  {
  factory $NeverHaveIEverConfigCopyWith(NeverHaveIEverConfig value, $Res Function(NeverHaveIEverConfig) _then) = _$NeverHaveIEverConfigCopyWithImpl;
@useResult
$Res call({
 int livesPerPlayer
});




}
/// @nodoc
class _$NeverHaveIEverConfigCopyWithImpl<$Res>
    implements $NeverHaveIEverConfigCopyWith<$Res> {
  _$NeverHaveIEverConfigCopyWithImpl(this._self, this._then);

  final NeverHaveIEverConfig _self;
  final $Res Function(NeverHaveIEverConfig) _then;

/// Create a copy of NeverHaveIEverConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? livesPerPlayer = null,}) {
  return _then(_self.copyWith(
livesPerPlayer: null == livesPerPlayer ? _self.livesPerPlayer : livesPerPlayer // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NeverHaveIEverConfig].
extension NeverHaveIEverConfigPatterns on NeverHaveIEverConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NeverHaveIEverConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NeverHaveIEverConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NeverHaveIEverConfig value)  $default,){
final _that = this;
switch (_that) {
case _NeverHaveIEverConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NeverHaveIEverConfig value)?  $default,){
final _that = this;
switch (_that) {
case _NeverHaveIEverConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int livesPerPlayer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NeverHaveIEverConfig() when $default != null:
return $default(_that.livesPerPlayer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int livesPerPlayer)  $default,) {final _that = this;
switch (_that) {
case _NeverHaveIEverConfig():
return $default(_that.livesPerPlayer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int livesPerPlayer)?  $default,) {final _that = this;
switch (_that) {
case _NeverHaveIEverConfig() when $default != null:
return $default(_that.livesPerPlayer);case _:
  return null;

}
}

}

/// @nodoc


class _NeverHaveIEverConfig extends NeverHaveIEverConfig {
  const _NeverHaveIEverConfig({this.livesPerPlayer = 3}): super._();
  

/// How many prompts a player can match before they're out.
@override@JsonKey() final  int livesPerPlayer;

/// Create a copy of NeverHaveIEverConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NeverHaveIEverConfigCopyWith<_NeverHaveIEverConfig> get copyWith => __$NeverHaveIEverConfigCopyWithImpl<_NeverHaveIEverConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NeverHaveIEverConfig&&(identical(other.livesPerPlayer, livesPerPlayer) || other.livesPerPlayer == livesPerPlayer));
}


@override
int get hashCode => Object.hash(runtimeType,livesPerPlayer);

@override
String toString() {
  return 'NeverHaveIEverConfig(livesPerPlayer: $livesPerPlayer)';
}


}

/// @nodoc
abstract mixin class _$NeverHaveIEverConfigCopyWith<$Res> implements $NeverHaveIEverConfigCopyWith<$Res> {
  factory _$NeverHaveIEverConfigCopyWith(_NeverHaveIEverConfig value, $Res Function(_NeverHaveIEverConfig) _then) = __$NeverHaveIEverConfigCopyWithImpl;
@override @useResult
$Res call({
 int livesPerPlayer
});




}
/// @nodoc
class __$NeverHaveIEverConfigCopyWithImpl<$Res>
    implements _$NeverHaveIEverConfigCopyWith<$Res> {
  __$NeverHaveIEverConfigCopyWithImpl(this._self, this._then);

  final _NeverHaveIEverConfig _self;
  final $Res Function(_NeverHaveIEverConfig) _then;

/// Create a copy of NeverHaveIEverConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? livesPerPlayer = null,}) {
  return _then(_NeverHaveIEverConfig(
livesPerPlayer: null == livesPerPlayer ? _self.livesPerPlayer : livesPerPlayer // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
