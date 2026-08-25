// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'night_resolution.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NightResolution {

/// The player who died overnight, or null if nobody did.
 String? get killedId;/// The player the mafia targeted but the doctor protected, or null.
 String? get savedId;
/// Create a copy of NightResolution
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NightResolutionCopyWith<NightResolution> get copyWith => _$NightResolutionCopyWithImpl<NightResolution>(this as NightResolution, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NightResolution&&(identical(other.killedId, killedId) || other.killedId == killedId)&&(identical(other.savedId, savedId) || other.savedId == savedId));
}


@override
int get hashCode => Object.hash(runtimeType,killedId,savedId);

@override
String toString() {
  return 'NightResolution(killedId: $killedId, savedId: $savedId)';
}


}

/// @nodoc
abstract mixin class $NightResolutionCopyWith<$Res>  {
  factory $NightResolutionCopyWith(NightResolution value, $Res Function(NightResolution) _then) = _$NightResolutionCopyWithImpl;
@useResult
$Res call({
 String? killedId, String? savedId
});




}
/// @nodoc
class _$NightResolutionCopyWithImpl<$Res>
    implements $NightResolutionCopyWith<$Res> {
  _$NightResolutionCopyWithImpl(this._self, this._then);

  final NightResolution _self;
  final $Res Function(NightResolution) _then;

/// Create a copy of NightResolution
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? killedId = freezed,Object? savedId = freezed,}) {
  return _then(_self.copyWith(
killedId: freezed == killedId ? _self.killedId : killedId // ignore: cast_nullable_to_non_nullable
as String?,savedId: freezed == savedId ? _self.savedId : savedId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NightResolution].
extension NightResolutionPatterns on NightResolution {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NightResolution value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NightResolution() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NightResolution value)  $default,){
final _that = this;
switch (_that) {
case _NightResolution():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NightResolution value)?  $default,){
final _that = this;
switch (_that) {
case _NightResolution() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? killedId,  String? savedId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NightResolution() when $default != null:
return $default(_that.killedId,_that.savedId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? killedId,  String? savedId)  $default,) {final _that = this;
switch (_that) {
case _NightResolution():
return $default(_that.killedId,_that.savedId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? killedId,  String? savedId)?  $default,) {final _that = this;
switch (_that) {
case _NightResolution() when $default != null:
return $default(_that.killedId,_that.savedId);case _:
  return null;

}
}

}

/// @nodoc


class _NightResolution extends NightResolution {
  const _NightResolution({this.killedId, this.savedId}): super._();
  

/// The player who died overnight, or null if nobody did.
@override final  String? killedId;
/// The player the mafia targeted but the doctor protected, or null.
@override final  String? savedId;

/// Create a copy of NightResolution
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NightResolutionCopyWith<_NightResolution> get copyWith => __$NightResolutionCopyWithImpl<_NightResolution>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NightResolution&&(identical(other.killedId, killedId) || other.killedId == killedId)&&(identical(other.savedId, savedId) || other.savedId == savedId));
}


@override
int get hashCode => Object.hash(runtimeType,killedId,savedId);

@override
String toString() {
  return 'NightResolution(killedId: $killedId, savedId: $savedId)';
}


}

/// @nodoc
abstract mixin class _$NightResolutionCopyWith<$Res> implements $NightResolutionCopyWith<$Res> {
  factory _$NightResolutionCopyWith(_NightResolution value, $Res Function(_NightResolution) _then) = __$NightResolutionCopyWithImpl;
@override @useResult
$Res call({
 String? killedId, String? savedId
});




}
/// @nodoc
class __$NightResolutionCopyWithImpl<$Res>
    implements _$NightResolutionCopyWith<$Res> {
  __$NightResolutionCopyWithImpl(this._self, this._then);

  final _NightResolution _self;
  final $Res Function(_NightResolution) _then;

/// Create a copy of NightResolution
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? killedId = freezed,Object? savedId = freezed,}) {
  return _then(_NightResolution(
killedId: freezed == killedId ? _self.killedId : killedId // ignore: cast_nullable_to_non_nullable
as String?,savedId: freezed == savedId ? _self.savedId : savedId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
