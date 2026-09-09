// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'heads_up_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HeadsUpConfig {

/// Seconds on the clock for each turn.
 int get roundSeconds;/// Turns each player gets before the scores are final.
 int get roundCount;
/// Create a copy of HeadsUpConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HeadsUpConfigCopyWith<HeadsUpConfig> get copyWith => _$HeadsUpConfigCopyWithImpl<HeadsUpConfig>(this as HeadsUpConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HeadsUpConfig&&(identical(other.roundSeconds, roundSeconds) || other.roundSeconds == roundSeconds)&&(identical(other.roundCount, roundCount) || other.roundCount == roundCount));
}


@override
int get hashCode => Object.hash(runtimeType,roundSeconds,roundCount);

@override
String toString() {
  return 'HeadsUpConfig(roundSeconds: $roundSeconds, roundCount: $roundCount)';
}


}

/// @nodoc
abstract mixin class $HeadsUpConfigCopyWith<$Res>  {
  factory $HeadsUpConfigCopyWith(HeadsUpConfig value, $Res Function(HeadsUpConfig) _then) = _$HeadsUpConfigCopyWithImpl;
@useResult
$Res call({
 int roundSeconds, int roundCount
});




}
/// @nodoc
class _$HeadsUpConfigCopyWithImpl<$Res>
    implements $HeadsUpConfigCopyWith<$Res> {
  _$HeadsUpConfigCopyWithImpl(this._self, this._then);

  final HeadsUpConfig _self;
  final $Res Function(HeadsUpConfig) _then;

/// Create a copy of HeadsUpConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roundSeconds = null,Object? roundCount = null,}) {
  return _then(_self.copyWith(
roundSeconds: null == roundSeconds ? _self.roundSeconds : roundSeconds // ignore: cast_nullable_to_non_nullable
as int,roundCount: null == roundCount ? _self.roundCount : roundCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HeadsUpConfig].
extension HeadsUpConfigPatterns on HeadsUpConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HeadsUpConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HeadsUpConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HeadsUpConfig value)  $default,){
final _that = this;
switch (_that) {
case _HeadsUpConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HeadsUpConfig value)?  $default,){
final _that = this;
switch (_that) {
case _HeadsUpConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int roundSeconds,  int roundCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HeadsUpConfig() when $default != null:
return $default(_that.roundSeconds,_that.roundCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int roundSeconds,  int roundCount)  $default,) {final _that = this;
switch (_that) {
case _HeadsUpConfig():
return $default(_that.roundSeconds,_that.roundCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int roundSeconds,  int roundCount)?  $default,) {final _that = this;
switch (_that) {
case _HeadsUpConfig() when $default != null:
return $default(_that.roundSeconds,_that.roundCount);case _:
  return null;

}
}

}

/// @nodoc


class _HeadsUpConfig extends HeadsUpConfig {
  const _HeadsUpConfig({this.roundSeconds = 60, this.roundCount = 1}): super._();
  

/// Seconds on the clock for each turn.
@override@JsonKey() final  int roundSeconds;
/// Turns each player gets before the scores are final.
@override@JsonKey() final  int roundCount;

/// Create a copy of HeadsUpConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HeadsUpConfigCopyWith<_HeadsUpConfig> get copyWith => __$HeadsUpConfigCopyWithImpl<_HeadsUpConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HeadsUpConfig&&(identical(other.roundSeconds, roundSeconds) || other.roundSeconds == roundSeconds)&&(identical(other.roundCount, roundCount) || other.roundCount == roundCount));
}


@override
int get hashCode => Object.hash(runtimeType,roundSeconds,roundCount);

@override
String toString() {
  return 'HeadsUpConfig(roundSeconds: $roundSeconds, roundCount: $roundCount)';
}


}

/// @nodoc
abstract mixin class _$HeadsUpConfigCopyWith<$Res> implements $HeadsUpConfigCopyWith<$Res> {
  factory _$HeadsUpConfigCopyWith(_HeadsUpConfig value, $Res Function(_HeadsUpConfig) _then) = __$HeadsUpConfigCopyWithImpl;
@override @useResult
$Res call({
 int roundSeconds, int roundCount
});




}
/// @nodoc
class __$HeadsUpConfigCopyWithImpl<$Res>
    implements _$HeadsUpConfigCopyWith<$Res> {
  __$HeadsUpConfigCopyWithImpl(this._self, this._then);

  final _HeadsUpConfig _self;
  final $Res Function(_HeadsUpConfig) _then;

/// Create a copy of HeadsUpConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roundSeconds = null,Object? roundCount = null,}) {
  return _then(_HeadsUpConfig(
roundSeconds: null == roundSeconds ? _self.roundSeconds : roundSeconds // ignore: cast_nullable_to_non_nullable
as int,roundCount: null == roundCount ? _self.roundCount : roundCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
