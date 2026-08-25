// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mafia_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MafiaConfig {

 int get mafiaCount;/// Whether the mafia may kill on the very first night.
 bool get firstNightKill;/// Whether the doctor may protect themselves.
 bool get doctorSelfSave;/// Whether an investigation reveals the exact role vs. just mafia/not.
 bool get detectiveExactRole;/// Whether a killed/lynched player's role is announced.
 bool get revealRolesOnDeath;
/// Create a copy of MafiaConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MafiaConfigCopyWith<MafiaConfig> get copyWith => _$MafiaConfigCopyWithImpl<MafiaConfig>(this as MafiaConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MafiaConfig&&(identical(other.mafiaCount, mafiaCount) || other.mafiaCount == mafiaCount)&&(identical(other.firstNightKill, firstNightKill) || other.firstNightKill == firstNightKill)&&(identical(other.doctorSelfSave, doctorSelfSave) || other.doctorSelfSave == doctorSelfSave)&&(identical(other.detectiveExactRole, detectiveExactRole) || other.detectiveExactRole == detectiveExactRole)&&(identical(other.revealRolesOnDeath, revealRolesOnDeath) || other.revealRolesOnDeath == revealRolesOnDeath));
}


@override
int get hashCode => Object.hash(runtimeType,mafiaCount,firstNightKill,doctorSelfSave,detectiveExactRole,revealRolesOnDeath);

@override
String toString() {
  return 'MafiaConfig(mafiaCount: $mafiaCount, firstNightKill: $firstNightKill, doctorSelfSave: $doctorSelfSave, detectiveExactRole: $detectiveExactRole, revealRolesOnDeath: $revealRolesOnDeath)';
}


}

/// @nodoc
abstract mixin class $MafiaConfigCopyWith<$Res>  {
  factory $MafiaConfigCopyWith(MafiaConfig value, $Res Function(MafiaConfig) _then) = _$MafiaConfigCopyWithImpl;
@useResult
$Res call({
 int mafiaCount, bool firstNightKill, bool doctorSelfSave, bool detectiveExactRole, bool revealRolesOnDeath
});




}
/// @nodoc
class _$MafiaConfigCopyWithImpl<$Res>
    implements $MafiaConfigCopyWith<$Res> {
  _$MafiaConfigCopyWithImpl(this._self, this._then);

  final MafiaConfig _self;
  final $Res Function(MafiaConfig) _then;

/// Create a copy of MafiaConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mafiaCount = null,Object? firstNightKill = null,Object? doctorSelfSave = null,Object? detectiveExactRole = null,Object? revealRolesOnDeath = null,}) {
  return _then(_self.copyWith(
mafiaCount: null == mafiaCount ? _self.mafiaCount : mafiaCount // ignore: cast_nullable_to_non_nullable
as int,firstNightKill: null == firstNightKill ? _self.firstNightKill : firstNightKill // ignore: cast_nullable_to_non_nullable
as bool,doctorSelfSave: null == doctorSelfSave ? _self.doctorSelfSave : doctorSelfSave // ignore: cast_nullable_to_non_nullable
as bool,detectiveExactRole: null == detectiveExactRole ? _self.detectiveExactRole : detectiveExactRole // ignore: cast_nullable_to_non_nullable
as bool,revealRolesOnDeath: null == revealRolesOnDeath ? _self.revealRolesOnDeath : revealRolesOnDeath // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MafiaConfig].
extension MafiaConfigPatterns on MafiaConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MafiaConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MafiaConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MafiaConfig value)  $default,){
final _that = this;
switch (_that) {
case _MafiaConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MafiaConfig value)?  $default,){
final _that = this;
switch (_that) {
case _MafiaConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int mafiaCount,  bool firstNightKill,  bool doctorSelfSave,  bool detectiveExactRole,  bool revealRolesOnDeath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MafiaConfig() when $default != null:
return $default(_that.mafiaCount,_that.firstNightKill,_that.doctorSelfSave,_that.detectiveExactRole,_that.revealRolesOnDeath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int mafiaCount,  bool firstNightKill,  bool doctorSelfSave,  bool detectiveExactRole,  bool revealRolesOnDeath)  $default,) {final _that = this;
switch (_that) {
case _MafiaConfig():
return $default(_that.mafiaCount,_that.firstNightKill,_that.doctorSelfSave,_that.detectiveExactRole,_that.revealRolesOnDeath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int mafiaCount,  bool firstNightKill,  bool doctorSelfSave,  bool detectiveExactRole,  bool revealRolesOnDeath)?  $default,) {final _that = this;
switch (_that) {
case _MafiaConfig() when $default != null:
return $default(_that.mafiaCount,_that.firstNightKill,_that.doctorSelfSave,_that.detectiveExactRole,_that.revealRolesOnDeath);case _:
  return null;

}
}

}

/// @nodoc


class _MafiaConfig extends MafiaConfig {
  const _MafiaConfig({this.mafiaCount = 1, this.firstNightKill = true, this.doctorSelfSave = true, this.detectiveExactRole = true, this.revealRolesOnDeath = true}): super._();
  

@override@JsonKey() final  int mafiaCount;
/// Whether the mafia may kill on the very first night.
@override@JsonKey() final  bool firstNightKill;
/// Whether the doctor may protect themselves.
@override@JsonKey() final  bool doctorSelfSave;
/// Whether an investigation reveals the exact role vs. just mafia/not.
@override@JsonKey() final  bool detectiveExactRole;
/// Whether a killed/lynched player's role is announced.
@override@JsonKey() final  bool revealRolesOnDeath;

/// Create a copy of MafiaConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MafiaConfigCopyWith<_MafiaConfig> get copyWith => __$MafiaConfigCopyWithImpl<_MafiaConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MafiaConfig&&(identical(other.mafiaCount, mafiaCount) || other.mafiaCount == mafiaCount)&&(identical(other.firstNightKill, firstNightKill) || other.firstNightKill == firstNightKill)&&(identical(other.doctorSelfSave, doctorSelfSave) || other.doctorSelfSave == doctorSelfSave)&&(identical(other.detectiveExactRole, detectiveExactRole) || other.detectiveExactRole == detectiveExactRole)&&(identical(other.revealRolesOnDeath, revealRolesOnDeath) || other.revealRolesOnDeath == revealRolesOnDeath));
}


@override
int get hashCode => Object.hash(runtimeType,mafiaCount,firstNightKill,doctorSelfSave,detectiveExactRole,revealRolesOnDeath);

@override
String toString() {
  return 'MafiaConfig(mafiaCount: $mafiaCount, firstNightKill: $firstNightKill, doctorSelfSave: $doctorSelfSave, detectiveExactRole: $detectiveExactRole, revealRolesOnDeath: $revealRolesOnDeath)';
}


}

/// @nodoc
abstract mixin class _$MafiaConfigCopyWith<$Res> implements $MafiaConfigCopyWith<$Res> {
  factory _$MafiaConfigCopyWith(_MafiaConfig value, $Res Function(_MafiaConfig) _then) = __$MafiaConfigCopyWithImpl;
@override @useResult
$Res call({
 int mafiaCount, bool firstNightKill, bool doctorSelfSave, bool detectiveExactRole, bool revealRolesOnDeath
});




}
/// @nodoc
class __$MafiaConfigCopyWithImpl<$Res>
    implements _$MafiaConfigCopyWith<$Res> {
  __$MafiaConfigCopyWithImpl(this._self, this._then);

  final _MafiaConfig _self;
  final $Res Function(_MafiaConfig) _then;

/// Create a copy of MafiaConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mafiaCount = null,Object? firstNightKill = null,Object? doctorSelfSave = null,Object? detectiveExactRole = null,Object? revealRolesOnDeath = null,}) {
  return _then(_MafiaConfig(
mafiaCount: null == mafiaCount ? _self.mafiaCount : mafiaCount // ignore: cast_nullable_to_non_nullable
as int,firstNightKill: null == firstNightKill ? _self.firstNightKill : firstNightKill // ignore: cast_nullable_to_non_nullable
as bool,doctorSelfSave: null == doctorSelfSave ? _self.doctorSelfSave : doctorSelfSave // ignore: cast_nullable_to_non_nullable
as bool,detectiveExactRole: null == detectiveExactRole ? _self.detectiveExactRole : detectiveExactRole // ignore: cast_nullable_to_non_nullable
as bool,revealRolesOnDeath: null == revealRolesOnDeath ? _self.revealRolesOnDeath : revealRolesOnDeath // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
