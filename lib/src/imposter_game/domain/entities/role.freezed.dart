// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Role {

 String? get categoryHint;
/// Create a copy of Role
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoleCopyWith<Role> get copyWith => _$RoleCopyWithImpl<Role>(this as Role, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Role&&(identical(other.categoryHint, categoryHint) || other.categoryHint == categoryHint));
}


@override
int get hashCode => Object.hash(runtimeType,categoryHint);

@override
String toString() {
  return 'Role(categoryHint: $categoryHint)';
}


}

/// @nodoc
abstract mixin class $RoleCopyWith<$Res>  {
  factory $RoleCopyWith(Role value, $Res Function(Role) _then) = _$RoleCopyWithImpl;
@useResult
$Res call({
 String? categoryHint
});




}
/// @nodoc
class _$RoleCopyWithImpl<$Res>
    implements $RoleCopyWith<$Res> {
  _$RoleCopyWithImpl(this._self, this._then);

  final Role _self;
  final $Res Function(Role) _then;

/// Create a copy of Role
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryHint = freezed,}) {
  return _then(_self.copyWith(
categoryHint: freezed == categoryHint ? _self.categoryHint : categoryHint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Role].
extension RolePatterns on Role {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CivilianRole value)?  civilian,TResult Function( ImposterRole value)?  imposter,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CivilianRole() when civilian != null:
return civilian(_that);case ImposterRole() when imposter != null:
return imposter(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CivilianRole value)  civilian,required TResult Function( ImposterRole value)  imposter,}){
final _that = this;
switch (_that) {
case CivilianRole():
return civilian(_that);case ImposterRole():
return imposter(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CivilianRole value)?  civilian,TResult? Function( ImposterRole value)?  imposter,}){
final _that = this;
switch (_that) {
case CivilianRole() when civilian != null:
return civilian(_that);case ImposterRole() when imposter != null:
return imposter(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String secretWord,  String? categoryHint)?  civilian,TResult Function( String? categoryHint,  String? decoyWord)?  imposter,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CivilianRole() when civilian != null:
return civilian(_that.secretWord,_that.categoryHint);case ImposterRole() when imposter != null:
return imposter(_that.categoryHint,_that.decoyWord);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String secretWord,  String? categoryHint)  civilian,required TResult Function( String? categoryHint,  String? decoyWord)  imposter,}) {final _that = this;
switch (_that) {
case CivilianRole():
return civilian(_that.secretWord,_that.categoryHint);case ImposterRole():
return imposter(_that.categoryHint,_that.decoyWord);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String secretWord,  String? categoryHint)?  civilian,TResult? Function( String? categoryHint,  String? decoyWord)?  imposter,}) {final _that = this;
switch (_that) {
case CivilianRole() when civilian != null:
return civilian(_that.secretWord,_that.categoryHint);case ImposterRole() when imposter != null:
return imposter(_that.categoryHint,_that.decoyWord);case _:
  return null;

}
}

}

/// @nodoc


class CivilianRole implements Role {
  const CivilianRole({required this.secretWord, this.categoryHint});
  

 final  String secretWord;
@override final  String? categoryHint;

/// Create a copy of Role
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CivilianRoleCopyWith<CivilianRole> get copyWith => _$CivilianRoleCopyWithImpl<CivilianRole>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CivilianRole&&(identical(other.secretWord, secretWord) || other.secretWord == secretWord)&&(identical(other.categoryHint, categoryHint) || other.categoryHint == categoryHint));
}


@override
int get hashCode => Object.hash(runtimeType,secretWord,categoryHint);

@override
String toString() {
  return 'Role.civilian(secretWord: $secretWord, categoryHint: $categoryHint)';
}


}

/// @nodoc
abstract mixin class $CivilianRoleCopyWith<$Res> implements $RoleCopyWith<$Res> {
  factory $CivilianRoleCopyWith(CivilianRole value, $Res Function(CivilianRole) _then) = _$CivilianRoleCopyWithImpl;
@override @useResult
$Res call({
 String secretWord, String? categoryHint
});




}
/// @nodoc
class _$CivilianRoleCopyWithImpl<$Res>
    implements $CivilianRoleCopyWith<$Res> {
  _$CivilianRoleCopyWithImpl(this._self, this._then);

  final CivilianRole _self;
  final $Res Function(CivilianRole) _then;

/// Create a copy of Role
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? secretWord = null,Object? categoryHint = freezed,}) {
  return _then(CivilianRole(
secretWord: null == secretWord ? _self.secretWord : secretWord // ignore: cast_nullable_to_non_nullable
as String,categoryHint: freezed == categoryHint ? _self.categoryHint : categoryHint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ImposterRole implements Role {
  const ImposterRole({this.categoryHint, this.decoyWord});
  

@override final  String? categoryHint;
 final  String? decoyWord;

/// Create a copy of Role
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImposterRoleCopyWith<ImposterRole> get copyWith => _$ImposterRoleCopyWithImpl<ImposterRole>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImposterRole&&(identical(other.categoryHint, categoryHint) || other.categoryHint == categoryHint)&&(identical(other.decoyWord, decoyWord) || other.decoyWord == decoyWord));
}


@override
int get hashCode => Object.hash(runtimeType,categoryHint,decoyWord);

@override
String toString() {
  return 'Role.imposter(categoryHint: $categoryHint, decoyWord: $decoyWord)';
}


}

/// @nodoc
abstract mixin class $ImposterRoleCopyWith<$Res> implements $RoleCopyWith<$Res> {
  factory $ImposterRoleCopyWith(ImposterRole value, $Res Function(ImposterRole) _then) = _$ImposterRoleCopyWithImpl;
@override @useResult
$Res call({
 String? categoryHint, String? decoyWord
});




}
/// @nodoc
class _$ImposterRoleCopyWithImpl<$Res>
    implements $ImposterRoleCopyWith<$Res> {
  _$ImposterRoleCopyWithImpl(this._self, this._then);

  final ImposterRole _self;
  final $Res Function(ImposterRole) _then;

/// Create a copy of Role
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryHint = freezed,Object? decoyWord = freezed,}) {
  return _then(ImposterRole(
categoryHint: freezed == categoryHint ? _self.categoryHint : categoryHint // ignore: cast_nullable_to_non_nullable
as String?,decoyWord: freezed == decoyWord ? _self.decoyWord : decoyWord // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
