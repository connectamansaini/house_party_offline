// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'round_assignment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoundAssignment {

 Map<String, Role> get rolesByPlayerId; String get secretWord; Set<String> get imposterIds;
/// Create a copy of RoundAssignment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoundAssignmentCopyWith<RoundAssignment> get copyWith => _$RoundAssignmentCopyWithImpl<RoundAssignment>(this as RoundAssignment, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoundAssignment&&const DeepCollectionEquality().equals(other.rolesByPlayerId, rolesByPlayerId)&&(identical(other.secretWord, secretWord) || other.secretWord == secretWord)&&const DeepCollectionEquality().equals(other.imposterIds, imposterIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(rolesByPlayerId),secretWord,const DeepCollectionEquality().hash(imposterIds));

@override
String toString() {
  return 'RoundAssignment(rolesByPlayerId: $rolesByPlayerId, secretWord: $secretWord, imposterIds: $imposterIds)';
}


}

/// @nodoc
abstract mixin class $RoundAssignmentCopyWith<$Res>  {
  factory $RoundAssignmentCopyWith(RoundAssignment value, $Res Function(RoundAssignment) _then) = _$RoundAssignmentCopyWithImpl;
@useResult
$Res call({
 Map<String, Role> rolesByPlayerId, String secretWord, Set<String> imposterIds
});




}
/// @nodoc
class _$RoundAssignmentCopyWithImpl<$Res>
    implements $RoundAssignmentCopyWith<$Res> {
  _$RoundAssignmentCopyWithImpl(this._self, this._then);

  final RoundAssignment _self;
  final $Res Function(RoundAssignment) _then;

/// Create a copy of RoundAssignment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rolesByPlayerId = null,Object? secretWord = null,Object? imposterIds = null,}) {
  return _then(_self.copyWith(
rolesByPlayerId: null == rolesByPlayerId ? _self.rolesByPlayerId : rolesByPlayerId // ignore: cast_nullable_to_non_nullable
as Map<String, Role>,secretWord: null == secretWord ? _self.secretWord : secretWord // ignore: cast_nullable_to_non_nullable
as String,imposterIds: null == imposterIds ? _self.imposterIds : imposterIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [RoundAssignment].
extension RoundAssignmentPatterns on RoundAssignment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoundAssignment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoundAssignment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoundAssignment value)  $default,){
final _that = this;
switch (_that) {
case _RoundAssignment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoundAssignment value)?  $default,){
final _that = this;
switch (_that) {
case _RoundAssignment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, Role> rolesByPlayerId,  String secretWord,  Set<String> imposterIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoundAssignment() when $default != null:
return $default(_that.rolesByPlayerId,_that.secretWord,_that.imposterIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, Role> rolesByPlayerId,  String secretWord,  Set<String> imposterIds)  $default,) {final _that = this;
switch (_that) {
case _RoundAssignment():
return $default(_that.rolesByPlayerId,_that.secretWord,_that.imposterIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, Role> rolesByPlayerId,  String secretWord,  Set<String> imposterIds)?  $default,) {final _that = this;
switch (_that) {
case _RoundAssignment() when $default != null:
return $default(_that.rolesByPlayerId,_that.secretWord,_that.imposterIds);case _:
  return null;

}
}

}

/// @nodoc


class _RoundAssignment extends RoundAssignment {
  const _RoundAssignment({required final  Map<String, Role> rolesByPlayerId, required this.secretWord, required final  Set<String> imposterIds}): _rolesByPlayerId = rolesByPlayerId,_imposterIds = imposterIds,super._();
  

 final  Map<String, Role> _rolesByPlayerId;
@override Map<String, Role> get rolesByPlayerId {
  if (_rolesByPlayerId is EqualUnmodifiableMapView) return _rolesByPlayerId;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_rolesByPlayerId);
}

@override final  String secretWord;
 final  Set<String> _imposterIds;
@override Set<String> get imposterIds {
  if (_imposterIds is EqualUnmodifiableSetView) return _imposterIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_imposterIds);
}


/// Create a copy of RoundAssignment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoundAssignmentCopyWith<_RoundAssignment> get copyWith => __$RoundAssignmentCopyWithImpl<_RoundAssignment>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoundAssignment&&const DeepCollectionEquality().equals(other._rolesByPlayerId, _rolesByPlayerId)&&(identical(other.secretWord, secretWord) || other.secretWord == secretWord)&&const DeepCollectionEquality().equals(other._imposterIds, _imposterIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_rolesByPlayerId),secretWord,const DeepCollectionEquality().hash(_imposterIds));

@override
String toString() {
  return 'RoundAssignment(rolesByPlayerId: $rolesByPlayerId, secretWord: $secretWord, imposterIds: $imposterIds)';
}


}

/// @nodoc
abstract mixin class _$RoundAssignmentCopyWith<$Res> implements $RoundAssignmentCopyWith<$Res> {
  factory _$RoundAssignmentCopyWith(_RoundAssignment value, $Res Function(_RoundAssignment) _then) = __$RoundAssignmentCopyWithImpl;
@override @useResult
$Res call({
 Map<String, Role> rolesByPlayerId, String secretWord, Set<String> imposterIds
});




}
/// @nodoc
class __$RoundAssignmentCopyWithImpl<$Res>
    implements _$RoundAssignmentCopyWith<$Res> {
  __$RoundAssignmentCopyWithImpl(this._self, this._then);

  final _RoundAssignment _self;
  final $Res Function(_RoundAssignment) _then;

/// Create a copy of RoundAssignment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rolesByPlayerId = null,Object? secretWord = null,Object? imposterIds = null,}) {
  return _then(_RoundAssignment(
rolesByPlayerId: null == rolesByPlayerId ? _self._rolesByPlayerId : rolesByPlayerId // ignore: cast_nullable_to_non_nullable
as Map<String, Role>,secretWord: null == secretWord ? _self.secretWord : secretWord // ignore: cast_nullable_to_non_nullable
as String,imposterIds: null == imposterIds ? _self._imposterIds : imposterIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
